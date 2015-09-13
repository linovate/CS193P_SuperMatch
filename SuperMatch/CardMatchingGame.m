//
//  CardMatchingGame.m
//  MatchingGame
//
//  Created by Viet Trinh on 12/10/14.
//  Copyright (c) 2014 VietTrinh. All rights reserved.
//

#import "CardMatchingGame.h"
#import "PlayingCard.h"

@interface CardMatchingGame()
@property (nonatomic, readwrite) NSInteger score;
@property (strong, nonatomic, readwrite) NSString* matchDetails;
@property (strong, nonatomic) NSMutableArray* cards;
@property (strong, nonatomic) NSMutableArray* comparingCards;
@end

@implementation CardMatchingGame

-(NSMutableArray*)cards{
    if(!_cards)
        _cards = [[NSMutableArray alloc] init];
    return _cards;
}

-(NSMutableArray*)comparingCards{
    if(!_comparingCards)
        _comparingCards = [[NSMutableArray alloc] init];
    return _comparingCards;
}

-(NSString*)matchDetails{
    if (!_matchDetails) {
        _matchDetails = @"";
    }
    return _matchDetails;
}

-(void)setTypeOfGame:(NSUInteger)typeOfGame{
    _typeOfGame = typeOfGame;
}

-(instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck*) deck{
    self = [super init];
    
    if(self){
        for (int i=0; i < count; i++) {
            /* this is actually a subclass of Card, not Card
             * because the deck is initialized with subclass of Card
             * in the Controller
             */
            Card* card = [deck drawRandomCard];
            if(card)
                [self.cards addObject:card];
            else{
                self = nil;
                break;
            }
        }
    }
    
    return self;
}

-(Card*)cardAtIndex:(NSUInteger)index{
    return (index < [self.cards count]) ? self.cards[index] : nil;
}

const int COST_TO_CHOOSE = 1;
const int MISMATCH_PENALTY = 2;
const int MATCH_BONUS = 4;

-(void)chooseCardAtIndex:(NSUInteger)index{
    Card* card = [self cardAtIndex:index];
    if(!card.isMatched){
        if (card.isChosen) {
            card.chosen = NO;
            self.matchDetails = [NSString stringWithFormat:@""];
        }
        else{
            for (Card* otherCard in self.cards) {
                if(otherCard.isChosen && !otherCard.isMatched){
                    // self.comparingCards is an array containing all cards on the table
                    // which are currently facing up and non-matched
                    [self.comparingCards addObject:otherCard];
                    /* ===== 2-card game is playing =====*/
                    if (self.typeOfGame == 2) {
                        [self matchingOtherCardsWithCard:card];
                        break; // only 2 cards are allowed to match
                    }
                    /* ===== 3-card game is playing =====*/
                    else if(self.typeOfGame == 3 && [self.comparingCards count] >= 2){
                        [self matchingOtherCardsWithCard:card];
                        break; // only 3 cards are allowed to match
                    }
                }
                else{
                    self.matchDetails = [NSString stringWithFormat:@"%@", card.contents];
                }
            }
            self.comparingCards = nil;
            card.chosen = YES;
            self.score -= COST_TO_CHOOSE;
        }
    }
}

-(void)matchingOtherCardsWithCard:(Card*)card{
    int matchScore = [card match:[NSArray arrayWithArray:self.comparingCards]];
    if(matchScore){
        self.score += matchScore * MATCH_BONUS;
        card.matched = YES;
        self.matchDetails = [NSString stringWithFormat:@"%@ matched ", card.contents];
        for (Card* cmpCard in self.comparingCards) {
            cmpCard.matched = YES;
            self.matchDetails = [self.matchDetails stringByAppendingString:[NSString stringWithFormat:@"%@ ",cmpCard.contents]];
        }
    }
    else{
        self.score -= MISMATCH_PENALTY;
        self.matchDetails = [NSString stringWithFormat:@"%@ dont' match ", card.contents];
        for (Card* cmpCard in self.comparingCards) {
            cmpCard.chosen = NO;
            self.matchDetails = [self.matchDetails stringByAppendingString:[NSString stringWithFormat:@"%@ ",cmpCard.contents]];
        }
    }
}

@end