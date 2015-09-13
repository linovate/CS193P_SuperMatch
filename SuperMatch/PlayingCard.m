//
//  PlayingCard.m
//  MatchingGame
//
//  Created by Viet Trinh on 12/10/14.
//  Copyright (c) 2014 VietTrinh. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

-(NSString*)contents{
    NSArray* rankSet = [PlayingCard validRanks];
    return [rankSet[self.rank] stringByAppendingString:self.suit];
}

+(NSArray*)validSuits{
    return @[@"♣️",@"♠️",@"♦️",@"♥️"];
}

+(NSArray*)validRanks{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+(NSUInteger)maxRank{
    return [[self validRanks] count] - 1;
}

@synthesize suit = _suit;

-(NSString*)suit{
    return _suit ? _suit : @"?";
}

-(void)setSuit:(NSString *)suit{
    if([[PlayingCard validSuits] containsObject:suit])
        _suit = suit;
}

-(void)setRank:(NSUInteger)rank{
    if(rank <= [PlayingCard maxRank])
        _rank = rank;
}

-(int)match:(NSArray *)otherCards{
    int score = 0;
    
    for (PlayingCard* card in otherCards) {
        if(card.rank == self.rank)
            score += 4;
        else if([card.suit isEqualToString:self.suit])
            score += 1;
    }
    
    return score;
}

@end