//
//  FATextViewWithMovableKeyboard.m
//  Gloocall
//
//  Created by Fadi on 1/2/16.
//  Copyright © 2016 Apprikot. All rights reserved.
//

#import "FATextViewWithMovableKeyboard.h"
#import "podImage.h"

@implementation FATextViewWithMovableKeyboard
@synthesize tap;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        //handle SHow keyboard
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShownHide:)
                                                     name:UIKeyboardWillShowNotification //UIKeyboardDidShowNotification
                                                   object:nil];
        //handle Hide keyboard
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShownHide:)
                                                     name:UIKeyboardWillHideNotification//UIKeyboardWillHideNotification
                                                   object:nil];
        
        tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideKeyboard)];

        super.delegate = self;
        
        if (CGRectEqualToRect(self.initFrame, CGRectZero)) {
            self.initFrame = self.superview.frame;
        }
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
    

}

-(void)removeMoving
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

- (void)layoutSubviews{
    
    [self addToolBar];
    [super layoutSubviews];
    [self layoutIfNeeded];
    
    if (!_moveWithKeyboard) {
        [self removeMoving];
    }
    
    if (!bottomBorder && _isBottomBorder) {
        CGFloat top = self.frame.size.height-1 + self.contentOffset.y;
        bottomBorder = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               top,
                                                               self.frame.size.width,
                                                               1)];
        [self addSubview:bottomBorder];
    }
    
    if (_isBottomBorder)
    {
        CGFloat top = self.frame.size.height-1 + self.contentOffset.y;
        bottomBorder.frame = CGRectMake(0,
                                        top,
                                        self.frame.size.width,
                                        1);
        bottomBorder.backgroundColor = isEditing ? _borderEditingColor : self.selected ? _borderSelectedColor : _borderColor;
    }
    else
    {
        self.layer.borderColor = isEditing ? [_borderEditingColor CGColor] : self.selected ? [_borderSelectedColor CGColor] : [_borderColor CGColor];
        self.layer.borderWidth = _borderWidth;
        //circle Image
        [self.layer setCornerRadius:_borderCorner];
        [self.layer setMasksToBounds:YES];
    }
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
//    if([super.delegate respondsToSelector:@selector(textViewDidBeginEditing:)]){
//        [super.delegate textViewDidBeginEditing:textView];
//    }
    isEditing = YES;
    [self layoutSubviews];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
//    if([super.delegate respondsToSelector:@selector(textViewDidEndEditing:)]){
//        [super.delegate textViewDidEndEditing:textView];
//    }
    isEditing = NO;
    [self layoutSubviews];
}

//Handle keyboard
- (void)keyboardWasShownHide:(NSNotification *)notification {
    // Get the size of the keyboard.
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    UIView *parant = self.superview;
    CGRect parantFrame = parant.frame;
    float animationDelay = 0;
    
//    if (CGRectEqualToRect(self.initFrame, CGRectZero)) {
//        self.initFrame = parant.frame;
//    }
    
    
    if (![parant.gestureRecognizers containsObject:tap]) {
        [parant addGestureRecognizer:tap];
    }
    else if(tap && [notification.name isEqualToString: UIKeyboardWillHideNotification]){
        [parant removeGestureRecognizer:tap];
    }
    
    //if textfield note foucesed
    if (![self isFirstResponder]) {
        return;
    }
    
    if ([parant.superview isKindOfClass:[UIScrollView class]]) {
        parantFrame.size = ((UIScrollView*)parant.superview).contentSize;
        
        //scroll to view
        CGRect frame = self.frame;
//        frame.size.height = (keyboardSize.height + frame.size.height + frame.origin.y) > parant.frame.size.height ? frame.size.height : (keyboardSize.height + frame.size.height);
//        frame.size.height =  parantFrame.size.height - frame.origin.y;
        frame.size.height +=  keyboardSize.height;
        
        [((UIScrollView*)parant.superview) scrollRectToVisible:frame animated:NO];
        animationDelay = 0.2;
    }
    
    //if view above keyboard
    if (((parantFrame.size.height - (self.frame.origin.y + self.frame.size.height)) > keyboardSize.height) &&  [notification.name isEqualToString: UIKeyboardWillShowNotification] ) {
        return;
    }
    
    NSDictionary* info = [notification userInfo];
    NSValue* value = [info objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    NSTimeInterval duration = 0;
    [value getValue:&duration];
    
    //animation time
    duration = ([notification.name isEqualToString: UIKeyboardWillShowNotification]  ? duration + 0.2 : duration - 0.5);
    const float movementDuration = duration ; // tweak as needed
    
    
    //set new y axis
    float y = (self.frame.origin.y + self.frame.size.height) - (parantFrame.size.height - (float)keyboardSize.height);
    
    //set new frame
    CGRect newFram = parant.frame;
    newFram.origin.y = ([notification.name isEqualToString: UIKeyboardWillShowNotification]  ? -y : self.initFrame.origin.y);
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, animationDelay * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        //make animation
        [UIView beginAnimations: @"anim" context: nil];
        [UIView setAnimationBeginsFromCurrentState: YES];
        [UIView setAnimationDuration: movementDuration];
        [UIView setAnimationDelay:animationDelay];
        //parant.frame = CGRectOffset(parant.frame, 0, movement);
        parant.frame = newFram;
        [UIView commitAnimations];
    });
    


}



-(void)addToolBar
{
    //add tool bar
    if (_toolBar && !self.inputAccessoryView) {
        UIToolbar* keyboardToolbar = [[UIToolbar alloc] init];
        [keyboardToolbar sizeToFit];
        UIBarButtonItem *nextBarButton,*preBarButton,*flexBarButton,*doneBarButton,*marginSpace;
        if (_toolBarNextPre) {
            BOOL hasNext = NO,hasPre = NO,Found = NO;
            
            for (UIView *item in self.superview.subviews) {
                if(([item isKindOfClass:[UITextField class]] || [item isKindOfClass:[UITextView class]]) && item.isUserInteractionEnabled && item != self && !Found)
                {
                    hasPre = YES;
                }
                
                if (item == self && !Found) {
                    Found = YES;
                }
                else if(([item isKindOfClass:[UITextField class]] || [item isKindOfClass:[UITextView class]])  && item.isUserInteractionEnabled && Found)
                {
                    hasNext = YES;
                    break;
                }
            }
            
            
            nextBarButton = [[UIBarButtonItem alloc] initWithImage:[podImage imageNamedFromPodResources:@"nextTextField"] style:UIBarButtonItemStylePlain target:self action:@selector(yourTextViewNextButtonPressed)];
            nextBarButton.enabled = hasNext;
            
            preBarButton = [[UIBarButtonItem alloc] initWithImage:[podImage imageNamedFromPodResources:@"preTextField"] style:UIBarButtonItemStylePlain target:self action:@selector(yourTextViewPreButtonPressed)];
            preBarButton.enabled = hasPre;
        }
        
        flexBarButton = [[UIBarButtonItem alloc]
                         initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                         target:nil action:nil];
        //        doneBarButton = [[UIBarButtonItem alloc]
        //                                          initWithBarButtonSystemItem:UIBarButtonSystemItemDone
        //                                          target:self action:@selector(yourTextViewDoneButtonPressed)];
        doneBarButton = [[UIBarButtonItem alloc]
                         initWithTitle:NSLocalizedString(@"Done", @"") style:UIBarButtonItemStyleDone target:self action:@selector(yourTextViewDoneButtonPressed)];
        marginSpace = [[UIBarButtonItem alloc]
                       initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                       target:nil action:nil];
        marginSpace.width = 5;
        
        
        keyboardToolbar.items = _toolBarNextPre ? @[preBarButton,nextBarButton,flexBarButton, doneBarButton,marginSpace]:@[flexBarButton, doneBarButton,marginSpace];
        if(_toolBarColor)
            keyboardToolbar.tintColor = _toolBarColor;
        self.inputAccessoryView = keyboardToolbar;
    }
}

-(void)hideKeyboard {
    [self.superview endEditing:YES];
}

//Hide in click Done
-(void)yourTextViewDoneButtonPressed
{
    [self resignFirstResponder];
}
//Next text field
-(void)yourTextViewNextButtonPressed
{
    BOOL Found = NO;
    for (UIView *item in self.superview.subviews) {
        if (item == self && !Found) {
            Found = YES;
        }
        else if(([item isKindOfClass:[UITextField class]] || [item isKindOfClass:[UITextView class]])  && item.isUserInteractionEnabled && Found)
        {
            [self hideKeyboard];
            [item becomeFirstResponder];
            return;
        }
    }
    [self resignFirstResponder];
}
//Pre text field
-(void)yourTextViewPreButtonPressed
{
    UIView *preView;
    for (UIView *item in self.superview.subviews) {
        if(([item isKindOfClass:[UITextField class]] || [item isKindOfClass:[UITextView class]])  && item.isUserInteractionEnabled && item != self)
        {
            preView = item;
        }
        else if(item == self)
        {
            [self hideKeyboard];
            [preView becomeFirstResponder];
            return;
        }
    }
    [self resignFirstResponder];
}

@end
