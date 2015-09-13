//
//  ViewController.m
//  SuperMatch
//
//  Created by Viet Trinh on 4/29/15.
//  Copyright (c) 2015 VietTrinh. All rights reserved.
//

#import "ViewController.h"
#import "CardMatchingGame.h"
#import "PlayingDeck.h"

@interface ViewController ()
@property (strong, nonatomic) CardMatchingGame* game;
// these 3 properties are mutual properties for outlets in both 2-card view and 3-card view
// you just have to click and drag items in views on storyboard to here
// Xcode will figure out which one belong to 2-card and which one belong to 3-card gaming
@property (strong, nonatomic) IBOutlet UILabel *scoreLabel;
@property (strong, nonatomic) IBOutlet UILabel *matchLabel;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@end

@implementation ViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.matchLabel.text = [NSString stringWithFormat:@""];
}

-(Deck*)createDeck{
    return [[PlayingDeck alloc] init];
}

-(CardMatchingGame*)game{;
    if(!_game){
        _game = [[CardMatchingGame alloc] initWithCardCount:[self.cardButtons count]
                                                    usingDeck:[self createDeck]];
        [self setTypeOfGame];
    }
    return _game;
}

-(void)setTypeOfGame{
    self.game.typeOfGame = [self setNumberOfCardMatch];
}

// this method will be overried in derived classes
// to determine with game (2-card or 3-card is playing)
-(NSUInteger)setNumberOfCardMatch{
    return 0;
}

// click and drag all card buttons on all UIView in storyboard to this method
// Xcode is smart enough to know which card-game we are playing, and which card buttons we touch
- (IBAction)touchCardButton:(UIButton *)sender {
    NSUInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex];
    [self updateView];
}

// click and drag all redeal buttons on all UIView in storyboard to this method
// Xcode is smart enough to know which card-game we are playing, and which re-deal button we click
- (IBAction)dealNewGame:(UIBarButtonItem *)sender {
    _game = nil;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score : 0"];
    self.matchLabel.text = [NSString stringWithFormat:@""];
    [self updateView];
}

-(void)updateView{
    
    for (UIButton* eachCardButton in self.cardButtons) {
        Card* card = [self.game cardAtIndex:[self.cardButtons indexOfObject:eachCardButton]];
        [eachCardButton setTitle:[self titleForCard:card]
                        forState:UIControlStateNormal];
        [eachCardButton setBackgroundImage:[self backgroundForCard:card]
                                  forState:UIControlStateNormal];
        eachCardButton.enabled = !card.isMatched;
    }
    //[self.scoreLabel setFont:[UIFont preferredFontForTextStyle:UIFontTextStyleBody]];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score : %d",(int)self.game.score];
    self.matchLabel.text = [NSString stringWithFormat:@"%@",self.game.matchDetails];
}


-(NSString*)titleForCard:(Card*)card{
    return card.isChosen ? card.contents : @"";
}

-(UIImage*)backgroundForCard:(Card*)card{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}


@end
