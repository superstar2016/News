//
//  ALViewsafeArea.h
//  naverdicapp
//
//  Created by naver on 2017/10/18.
//  Copyright © 2017年 Naver_China. All rights reserved.
//


#import <PureLayout/PureLayout.h>
#import <PureLayout/PureLayout+Internal.h>
@interface ALView (safeArea)
#pragma mark Pin Edges to SafeArea

#if PL__PureLayout_MinBaseSDK_iOS_8_0
/** Pins the given edge of the view to the same edge of its superview anchor. */
- (NSLayoutConstraint *)autoPinEdgeToSuperviewSafeArea:(ALEdge)edge;

/** Pins the given edge of the view to the same edge of its superview anchor with an inset. */
- (NSLayoutConstraint *)autoPinEdgeToSuperviewSafeArea:(ALEdge)edge withInset:(CGFloat)inset;

/** Pins the edges of the view to the edges of its superview anchors. */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoPinEdgesToSuperviewSafeArea;

/** Pins the edges of the view to the edges of its superview anchors with the given edge insets. */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoPinEdgesToSuperviewSafeAreaWithInsets:(ALEdgeInsets)insets;

- (PL__NSArray_of(NSLayoutConstraint *) *)autoPinEdgesToSuperviewSafeAreaWithInsets:(ALEdgeInsets)insets excludingEdge:(ALEdge)edge;
- (NSLayoutConstraint *)autoPinEdgeToSuperviewSafeArea:(ALEdge)edge toEdge:(ALEdge)toEdge;
- (NSLayoutConstraint *)autoPinEdgeToSuperviewSafeArea:(ALEdge)edge toEdge:(ALEdge)toEdge  withOffset:(CGFloat)offset;
#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 */
@end

