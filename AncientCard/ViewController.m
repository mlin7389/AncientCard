//
//  ViewController.m
//  AncientCard
//
//  Created by MartyLin on 10/20/14.
//  Copyright (c) 2014 MartyLin. All rights reserved.
//
@import AVFoundation;

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,weak) IBOutlet UIImageView *imgBackground;
@property (nonatomic,weak) IBOutlet UIImageView *img1;
@property (nonatomic,weak) IBOutlet UIImageView *img2;
@property (nonatomic,weak) IBOutlet UIImageView *img3;
@property (nonatomic,weak) IBOutlet UIImageView *img4;
@property (nonatomic,weak) IBOutlet UIImageView *img5;
@property (nonatomic,weak) IBOutlet UIImageView *img6;
@property (nonatomic,weak) IBOutlet UILabel *TitleLabel;
@property (nonatomic,weak) IBOutlet UIButton *btnStart;
@property (nonatomic,weak) IBOutlet UIButton *btnSelectDone;
@property (nonatomic,retain) IBOutlet UIImageView *imgGlow;
@property (nonatomic,retain) IBOutlet UIImageView *imgGlowWhite;
@property (nonatomic,weak) IBOutlet UILabel *TitlePress;
@property (weak, nonatomic) IBOutlet UIButton *reStart;
@property (weak, nonatomic) IBOutlet UIButton *audioButton;
@property (weak, nonatomic) IBOutlet UIButton *GoReviewbutton;
@end


@implementation ViewController {
    NSTimer *timer;
    NSTimer *timer2;
    float t;
    AVAudioPlayer *_newAudio;
    SystemSoundID ssd;
    SystemSoundID ssd2;
    SystemSoundID ssd3;
    int animIndex;
    NSMutableArray *imgList;
    NSMutableArray *colorArray;
    NSMutableArray *colorAnswerArray;
    int PressCount;
    BOOL playAudio;
}


-(void) ro {
    t+=0.003;
    [self.imgBackground setTransform:CGAffineTransformMakeRotation(t)];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path1=[[NSBundle mainBundle] pathForResource:@"btn" ofType:@"wav"];
    NSURL *url1 = [[NSURL alloc] initFileURLWithPath:path1];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url1,&ssd);
    
    
    NSString *path2=[[NSBundle mainBundle] pathForResource:@"cardout" ofType:@"wav"];
    NSURL *url2 = [[NSURL alloc] initFileURLWithPath:path2];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url2,&ssd2);
    
    NSString *path3=[[NSBundle mainBundle] pathForResource:@"Light" ofType:@"wav"];
    NSURL *url3 = [[NSURL alloc] initFileURLWithPath:path3];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)url3,&ssd3);
    
    
    imgList = [[NSMutableArray alloc] initWithObjects:self.img1,self.img2,self.img3,self.img4,self.img5,self.img6,nil];
    timer2 = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(ro) userInfo:nil repeats:YES];
    
    playAudio = ![[NSUserDefaults standardUserDefaults] boolForKey:@"audio"];
    if (playAudio == YES) {
        self.audioButton.alpha = 0.7;
    }
    else {
        self.audioButton.alpha = 0.3;
    }
    
    self.imgGlow.alpha = 0.0f;
    self.imgGlowWhite.alpha = 0.0f;
    self.btnSelectDone.alpha = 0.0f;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [self.TitleLabel setText:NSLocalizedString(@"page2",nil)];
    }
    else {
        [self.TitleLabel setText:NSLocalizedString(@"page1",nil)];
    }

    [self.TitlePress setText:NSLocalizedString(@"PressAndHold",nil)];
    [self.TitlePress setAlpha:0.0f];
    [self.TitleLabel setAlpha:0.0f];
    [self.btnStart setAlpha:0.0f];
    [self.reStart setAlpha:0.0f];
    [self.GoReviewbutton setAlpha:0.0f];
    [self.reStart setTitle:NSLocalizedString(@"reSatrt",nil) forState:UIControlStateNormal];
    [self.GoReviewbutton setTitle:NSLocalizedString(@"GoReview",nil) forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewDidAppear:(BOOL)animated {
    NSString *musicFilePath = [[NSBundle mainBundle] pathForResource:@"cardback" ofType:@"mp3"];       //創建音樂文件路徑
    NSURL *musicURL = [[NSURL alloc] initFileURLWithPath:musicFilePath];
     _newAudio = [[AVAudioPlayer alloc] initWithContentsOfURL:musicURL error:nil];
    if (playAudio == YES) {
        [_newAudio play];
        [_newAudio setVolume:0.8f];
    }
    else {
        [_newAudio play];
        [_newAudio setVolume:0.0f];
    }

    [UIView animateWithDuration:2.0f animations:^(void){
        [self.TitleLabel setAlpha:1.0f];
        [self.btnStart setAlpha:1.0f];
     }];
}


-(IBAction) BtnStart{
    
    if (self.btnStart.tag == 1) { //開始
        
        if (playAudio == YES) {
            AudioServicesPlaySystemSound(ssd);
        }
        [UIView beginAnimations:@"lbl1" context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:1.0f];
        [self.TitleLabel setAlpha:0.0];
        [self.btnStart setAlpha:0.0];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(CardWillStartOut)];
        [UIView commitAnimations];
    }
    else if (animIndex == 2){
        if (playAudio == YES) {
            AudioServicesPlaySystemSound(ssd);
        }
       
        for (int i=0;i< [imgList count]; i++) {
            [UIView beginAnimations:@"animationID" context:nil];
            [UIView setAnimationDuration:1.0f];
            [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
            [UIView setAnimationRepeatAutoreverses:NO];
            [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[imgList objectAtIndex:i] cache:YES];
            [self.TitleLabel setAlpha:0.0f];
            [self.btnStart setAlpha:0.0];
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
            {
              [[imgList objectAtIndex:i] setImage:[UIImage imageNamed:@"cardbackPad"]];
            }
            else {
                [[imgList objectAtIndex:i] setImage:[UIImage imageNamed:@"cardback"]];
            }
            
            
            if (i == [imgList count]-1) {
                [UIView setAnimationDelegate:self];
                [UIView setAnimationDidStopSelector:@selector(SelBtnDone)];
            }
            [UIView commitAnimations];
        }
    }
}

-(void) CardWillStartOut {
    if (self.btnStart.tag == 1) { //開始
       
        [self.TitleLabel setText:NSLocalizedString(@"tapCard",nil)];
        animIndex = 2;
        [UIView animateWithDuration:1.0f animations:^(void){
            [self.TitleLabel setAlpha:1.0f];
        } completion:^(BOOL finished){
            [self initCard];
            [self cardOut];
        }];
    }
}
-(void) cardOutDone {
    [self.btnStart setImage:[UIImage imageNamed:@"imgSelect"] forState:UIControlStateNormal];
    [self.btnStart setTag:2];
    [UIView animateWithDuration:1.0f animations:^(void){
        [self.btnStart setAlpha:1.0f];
    }];
}


//初化卡片
-(void) initCard{
    srandom([[NSDate date] timeIntervalSinceReferenceDate]);

    NSString *pad = @"";
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        pad = @"Pad";
    }
    
    
    colorArray = [[NSMutableArray alloc] init];
    colorAnswerArray = [[NSMutableArray alloc] init];
    int colorIndex= (random() % 2);
    int colorTypeIndex= (random() % 2);
    int colorTypeIndexCount = 0;
    for (int i = 0; i < 6 ; i++ ) {
        if (colorIndex == 0) {
            [colorArray addObject:[NSString stringWithFormat:@"R%i",colorTypeIndex]];
            if (colorTypeIndex == 0) {
                [colorAnswerArray  addObject:@"R1"];
            }
            else {
                [colorAnswerArray  addObject:@"R0"];
            }
            colorIndex = 1;
        }
        else {
            [colorArray addObject:[NSString stringWithFormat:@"B%i",colorTypeIndex]];
            if (colorTypeIndex == 0) {
                [colorAnswerArray  addObject:@"B1"];
            }
            else {
                [colorAnswerArray  addObject:@"B0"];
            }
            colorIndex = 0;
        }
        colorTypeIndexCount+=1;
        if (colorTypeIndexCount == 2) {
            if (colorTypeIndex < 1) {
                colorTypeIndex += 1;
            }
            else {
                colorTypeIndex = 0;
            }
            colorTypeIndexCount=0;
        }
    }
    int numberIndex= (random() % 3) + 1;
    for (int i = 0; i < 6 ; i++ ) {
        [colorArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@%i%@",[colorArray objectAtIndex:i],numberIndex,pad]];
        [colorAnswerArray replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@%i%@",[colorAnswerArray objectAtIndex:i],numberIndex,pad]];
        if (numberIndex < 3) {
            numberIndex += 1;
        }
        else {
            numberIndex = 1;
        }
    }
    
    int index = 0;
    for (UIImageView *imgView in imgList) {
        [imgView setImage:[UIImage imageNamed:[colorArray objectAtIndex:index]]];
         index+=1;
    }

    
    [self.img1 setCenter:CGPointMake(-self.img1.frame.size.width/2, self.img1.center.y)];
    [self.img2 setCenter:CGPointMake(-self.img2.frame.size.width/2, self.img2.center.y)];
    [self.img3 setCenter:CGPointMake(-self.img3.frame.size.width/2, self.img3.center.y)];
    [self.img4 setCenter:CGPointMake(-self.img4.frame.size.width/2, self.img4.center.y)];
    [self.img5 setCenter:CGPointMake(-self.img5.frame.size.width/2, self.img5.center.y)];
    [self.img6 setCenter:CGPointMake(-self.img6.frame.size.width/2, self.img6.center.y)];
    
 
}

//卡片滑出
-(void) cardOut {
    CGRect screenBounds=[[UIScreen mainScreen] bounds];
    int xloc = 0;
    float CardWidth = self.img1.frame.size.width/2;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
       xloc = 17 + CardWidth;
    }
    else {
        if (screenBounds.size.width == 480) {
            xloc = 5 + CardWidth;
        }
        else  {
            xloc = 21 + CardWidth;
        }
    }
   
   
    
    float de = 0.2f;
    float du = 0.0f;
    for (int i = 0 ; i < [imgList count];i++) {
        UIImageView *imgView = [imgList objectAtIndex:i];
        de = 0.2f;
        du += de+0.1f;
        if (i == [imgList count] -1) {
            [UIView beginAnimations:[NSString stringWithFormat:@"%i",i] context:nil];
            [UIView	setAnimationDelay:de];
            [UIView setAnimationDuration:du];
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(cardOutDone)];
            [imgView setCenter:CGPointMake(xloc, imgView.center.y)];
            [UIView commitAnimations];
        }
        else {
            [UIView beginAnimations:[NSString stringWithFormat:@"%i",i] context:nil];
            [UIView	setAnimationDelay:de];
            [UIView setAnimationDuration:du];
            [imgView setCenter:CGPointMake(xloc, imgView.center.y)];
            [UIView commitAnimations];
        }
     
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            xloc += 17 + CardWidth*2;
        }
        else {
            if (screenBounds.size.width == 480) {
                xloc += 10 + CardWidth*2;
            }
            else {
                xloc += 21 + CardWidth*2;
            }
        }
       
    }
}


-(void) SelBtnDone {
    [self.TitleLabel setText:NSLocalizedString(@"readmind",nil)];
    [UIView beginAnimations:@"lbl2" context:nil];
    [UIView setAnimationDuration:1.0f];
    [self.TitleLabel setAlpha:1.0f];
    [UIView commitAnimations];
    float de = 0.2f;
    float du = 0.0f;
    for (int i = 0 ; i < [imgList count]-3;i++) {
        de = 0.2f;
        du += de+0.1f;
        [UIView beginAnimations:[NSString stringWithFormat:@"A%i",i] context:nil];
        [UIView	setAnimationDelay:de];
        [UIView setAnimationDuration:du];
        [[imgList objectAtIndex:i] setCenter:self.view.center];
        [UIView commitAnimations];
    }
    for (int i = 3 ; i < [imgList count];i++) {
        [UIView beginAnimations:[NSString stringWithFormat:@"B%i",i] context:nil];
        [UIView setAnimationDuration:1.0f];
        if ( i == [imgList count]-1) {
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(pickerCard)];
        }
        [self.TitlePress setAlpha:1.0f];
        [[imgList objectAtIndex:i]  setCenter:self.view.center];
        [UIView commitAnimations];
    }
}
-(void) pickerCard {
    [self.btnSelectDone setAlpha:1.0f];
}


-(IBAction)  pickerBtnPress {
    if (playAudio == YES) {
       AudioServicesPlaySystemSound(ssd3);
    }
    
    [UIView beginAnimations:@"btn1" context:nil];
    [UIView setAnimationDuration:1.0f];
    [self.imgGlow setAlpha:1.0f];
    [UIView commitAnimations];
    PressCount=0;
    timer=[NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(doCount) userInfo:nil repeats:YES];
}
-(void) doCount {
    PressCount+=1;
    if (PressCount == 3) {
        [timer invalidate];
        if (playAudio == YES) {
            AudioServicesPlaySystemSound(ssd3);
        }
        [UIView beginAnimations:@"btn1" context:nil];
        [UIView setAnimationDuration:1.0f];
        [self.imgGlow setAlpha:0.0f];
        [self.imgGlowWhite setAlpha:1.0f];
        [UIView commitAnimations];
    }
}
-(IBAction)  pickerBtnClick{
    if (PressCount < 3) {
        PressCount =0;
        [timer invalidate];
        [UIView beginAnimations:@"btn1" context:nil];
        [UIView setAnimationDuration:1.0f];
        [self.imgGlow setAlpha:0.0f];
        [UIView commitAnimations];
    }
    else {
        [UIView beginAnimations:@"btn2" context:nil];
        [UIView setAnimationDuration:1.0f];
        [UIView setAnimationDelay:0.5f];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(WhiteCardOut)];
        [UIView commitAnimations];
    }
}
-(void) WhiteCardOut {
    if (playAudio == YES) {
        AudioServicesPlaySystemSound(ssd2);
    }
    
    [UIView beginAnimations:@"WhiteCardOut" context:nil];
    [UIView setAnimationDuration:1.0f];
    
    [self.img1 setCenter:CGPointMake(self.img1.center.x/2, self.img1.center.y)];
    [self.imgGlowWhite setCenter:self.img1.center];
 
    CGAffineTransform transform = CGAffineTransformMakeRotation(3.14);
    [self.imgGlowWhite setTransform:transform];
    [self.img1 setTransform:transform];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(WhiteCardDispos)];
    [UIView commitAnimations];
}

-(void) WhiteCardDispos {
    [UIView beginAnimations:@"WhiteCardDispos" context:nil];
    [UIView setAnimationDuration:1.0f];
    
    [self.img1 setCenter:CGPointMake(-self.img1.frame.size.width, -self.img1.frame.size.height)];
    [self.imgGlowWhite setCenter:self.img1.center];

    CGAffineTransform transform = CGAffineTransformMakeRotation(-3.14);
    [self.imgGlowWhite setTransform:transform];
    [self.img1 setTransform:transform];
    
    [self.btnSelectDone setAlpha:0.0f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(fiveOut)];
    [UIView commitAnimations];
}
-(void) fiveOut {
    float CardWidth = self.img1.frame.size.width/2;
    CGAffineTransform transform = CGAffineTransformMakeRotation(0);
    [self.imgGlowWhite setTransform:transform];
    [self.img1 setTransform:transform];
    CGRect screenBounds=[[UIScreen mainScreen] bounds];
    int xloc = 0;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        xloc = 45 + CardWidth;
    }
    else {
        if (screenBounds.size.width == 480) {
            xloc = 15 + CardWidth;
        }
        else {
            xloc = 35 + CardWidth;
        }
    }
    


    float de = 0.2f;
    float du = 0.0f;
    for (int i = 1; i < [imgList count];i++) {
        
        de = 0.2f;
        du += de+0.1f;
        [UIView beginAnimations:[NSString stringWithFormat:@"%i",i] context:nil];
        [UIView setAnimationDelay:de];
        [UIView setAnimationDuration:du];
        
        if (i==1) {
            [self.TitleLabel setAlpha:0.0f];
            [self.TitlePress setAlpha:0.0f];
        }
        if (i == [imgList count]-1) {
            [UIView setAnimationDelegate:self];
            [UIView setAnimationDidStopSelector:@selector(endAn)];
        }
        UIImageView *imgView = [imgList objectAtIndex:i];
        [imgView setCenter:CGPointMake(xloc, imgView.center.y)];
        [UIView commitAnimations];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            xloc += 45 + CardWidth*2;
        }
        else {
            if (screenBounds.size.width == 480) {
                xloc += 25 + CardWidth*2;
            }
            else {
                xloc += 35 + CardWidth*2;
            }
        }

    }
}

-(void) endAn {
    [self.TitleLabel setText:NSLocalizedString(@"lastPage",nil)];
    [UIView beginAnimations:@"end" context:nil];
    [UIView setAnimationDuration:5.0f];
    [self.TitleLabel setAlpha:1.0f];
    [self.TitlePress setAlpha:0.0f];
    self.reStart.alpha = 0.0f;
    [self.GoReviewbutton setAlpha:0.0f];
    [UIView commitAnimations];
    for (int i=0;i< [colorAnswerArray count]; i++) {
        [UIView beginAnimations:@"animationID" context:nil];
        [UIView setAnimationDuration:1.0f];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:[imgList objectAtIndex:i] cache:YES];
        [[imgList objectAtIndex:i] setImage:[UIImage imageNamed:[colorAnswerArray objectAtIndex:i]]];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(endAn2)];
        [UIView commitAnimations];
    }
}
-(void)endAn2 {
    [UIView animateWithDuration:1.0f animations:^(void){
        self.reStart.alpha = 1.0f;
        [self.GoReviewbutton setAlpha:1.0f];
    }];
}



- (IBAction)reStartTap:(id)sender {
    
    self.imgGlowWhite.alpha = 0.0f;
    self.imgGlowWhite.center = self.imgGlow.center;
    PressCount = 0;
    imgList = [[NSMutableArray alloc] initWithObjects:self.img1,self.img2,self.img3,self.img4,self.img5,self.img6,nil];
    [UIView animateWithDuration:1.0f animations:^(void){
        for (UIImageView *imgView in self->imgList) {
            imgView.alpha = 0.0f;
            
        }
        self.reStart.alpha = 0.0f;
        [self.GoReviewbutton setAlpha:0.0f];
        [self.TitleLabel setAlpha:0.0f];
        [self.TitlePress setAlpha:0.0f];
    } completion:^(BOOL finished){
        for (UIImageView *imgView in self->imgList) {
            imgView.center  = CGPointMake(-imgView.frame.size.width/2, self.view.center.y);
            
        }
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
           [self.TitleLabel setText:NSLocalizedString(@"page2",nil)];
        }
        else {
            [self.TitleLabel setText:NSLocalizedString(@"page1",nil)];
        }
        
        [self.TitlePress setText:NSLocalizedString(@"PressAndHold",nil)];
        
        [UIView animateWithDuration:1.0f animations:^(void){
 
            [self.btnStart setImage:[UIImage imageNamed:@"imgStart"] forState:UIControlStateNormal];
            [self.TitleLabel setAlpha:1.0f];
            [self.btnStart setAlpha:1.0f];
            self.btnStart.tag  = 1;
            
            for (UIImageView *imgView in self->imgList) {
                imgView.alpha = 1.0f;

            }
        }];
    }];
}
- (IBAction)AudioPlay:(id)sender {
    [[NSUserDefaults standardUserDefaults] setBool:!playAudio forKey:@"audio"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    playAudio = !playAudio;
    if (playAudio == YES) {
        [_newAudio setVolume:0.8f];
    }
    else {
        [_newAudio setVolume:0.0f];
    }
    if (playAudio == YES) {
        self.audioButton.alpha = 0.7;
    }
    else {
        self.audioButton.alpha = 0.3;
    }
}
- (IBAction)GoREviewTap:(id)sender {
    //https://itunes.apple.com/tw/app/shen-mi-du-xin-shu/id389944991?l=zh&mt=8
    NSString *productid = @"389944991";
    [[UIApplication sharedApplication] openURL:([NSURL URLWithString:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@", productid]])];
}


@end
