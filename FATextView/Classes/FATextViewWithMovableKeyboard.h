//
//  FATextViewWithMovableKeyboard.h
//  Gloocall
//
//  Created by Fadi on 1/2/16.
//  Copyright © 2016 Apprikot. All rights reserved.
//

#import <UIKit/UIKit.h>
//View IBInspectable property in UI
IB_DESIGNABLE
@interface FATextViewWithMovableKeyboard : UITextView<UITextViewDelegate>
{
    UIView *bottomBorder;
    BOOL isEditing;
}

@property (nonatomic) IBInspectable BOOL toolBar;
@property (nonatomic) IBInspectable BOOL toolBarNextPre;
@property (nonatomic,retain) IBInspectable UIColor *toolBarColor;


@property (nonatomic) IBInspectable BOOL isBottomBorder;

#pragma mark UI Property
/**
 * Border Color
 */
@property (nonatomic,retain) IBInspectable UIColor *borderColor;
/**
 * Selected Border Color
 */
@property (nonatomic,retain) IBInspectable UIColor *borderSelectedColor;
/**
 * Highlighted Border Color
 */
@property (nonatomic,retain) IBInspectable UIColor *borderEditingColor;
/**
 * Border Width
 */
@property (nonatomic) IBInspectable CGFloat borderWidth;
/**
 * Corner
 */
@property (nonatomic) IBInspectable CGFloat borderCorner;
/**
 * X padding
 */
@property (nonatomic) IBInspectable CGFloat textStartPadding;
/**
 * Y padding
 */
@property (nonatomic) IBInspectable CGFloat textTopPadding;
/**
 * Limit number of Characters
 */
@property (nonatomic) IBInspectable CGFloat textLimitCharacters;
/**
 * Allow view to move with keyboard
 *
 * Defaults false
 */
@property (nonatomic) IBInspectable BOOL moveWithKeyboard;

@property (nonatomic) IBInspectable BOOL selected;

@property (nonatomic) CGRect initFrame;
@property (strong,nonatomic) UITapGestureRecognizer *tap ;


-(void)hideKeyboard;
- (void)keyboardWasShownHide:(NSNotification *)notification;
@end

