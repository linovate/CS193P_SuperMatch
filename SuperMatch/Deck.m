//
//  Deck.m
//  MatchingGame
//
//  Created by Viet Trinh on 12/10/14.
//  Copyright (c) 2014 VietTrinh. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong,nonatomic) NSMutableArray* cardSet; // of Card
@end

@implementation Deck

-(NSMutableArray*)cardSet{
    if(!_cardSet)
        _cardSet = [[NSMutableArray alloc] init];
    return _cardSet;
}

-(void)addCard:(Card *)card atTop:(BOOL)atTop{
    if (atTop)
        [self.cardSet insertObject:card atIndex:0];
    else
        [self.cardSet addObject:card];
}

-(void)addCard:(Card *)card{
    [self addCard:card atTop:NO];
}

-(Card*)drawRandomCard{
    Card* card = nil;
    
    if ([self.cardSet count]) {
        unsigned index = arc4random() % [self.cardSet count];
        card = self.cardSet[index];
        [self.cardSet removeObjectAtIndex:index];
    }
    
    return card;
}

@end