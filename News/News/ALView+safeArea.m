//
//  ALViewsafeArea.m
//  naverdicapp
//
//  Created by naver on 2017/10/18.
//  Copyright © 2017年 Naver_China. All rights reserved.
//

#import "ALView+safeArea.h"

@implementation ALView (safeArea)
#pragma mark Pin Edges to SafeArea

#if PL__PureLayout_MinBaseSDK_iOS_8_0

/**
   Pins the given edge of the view to the same edge of its superview anchor.
 
   @param edge The edge of this view and its superview to pin.
   @return The constraint added.
   */
- (NSLayoutConstraint *)autoPinEdgeToSuperviewSafeArea:(ALEdge)edge
{
        return [self autoPinEdgeToSuperviewSafeArea:edge withInset:0.0];
    }

/**
   Pins the given edge of the view to the same edge of its superview anchor with an inset.
 
   @param edge The edge of this view and its superview to pin.
   @param inset The amount to inset this view's edge from the superview's edge.
   @return The constraint added.
   */
- (NSLayoutConstraint *)autoPinEdgeToSuperviewSafeArea:(ALEdge)edge withInset:(CGFloat)inset
{
//        self.translatesAutoresizingMaskIntoConstraints = NO;
//
//        ALView *superview = self.superview;
//        NSLayoutConstraint *constraint = nil;
//
//        NSLayoutYAxisAnchor *topAnchor;
//        NSLayoutYAxisAnchor *bottomAnchor;
//        NSLayoutXAxisAnchor *leftAnchor;
//        NSLayoutXAxisAnchor *rightAnchor;
//        NSLayoutXAxisAnchor *leadingAnchor;
//        NSLayoutXAxisAnchor *trailingAnchor;
//        if (@available(iOS 11.0, tvOS 11.0, *)) {
//                topAnchor = superview.safeAreaLayoutGuide.topAnchor;
//                bottomAnchor = superview.safeAreaLayoutGuide.bottomAnchor;
//                leftAnchor = superview.safeAreaLayoutGuide.leftAnchor;
//                rightAnchor = superview.safeAreaLayoutGuide.rightAnchor;
//                leadingAnchor = superview.safeAreaLayoutGuide.leadingAnchor;
//                trailingAnchor = superview.safeAreaLayoutGuide.trailingAnchor;
//            } else {
//                    topAnchor = superview.topAnchor;
//                    bottomAnchor = superview.bottomAnchor;
//                    leftAnchor = superview.leftAnchor;
//                    rightAnchor = superview.rightAnchor;
//                    leadingAnchor = superview.leadingAnchor;
//                    trailingAnchor = superview.trailingAnchor;
//                }
//
//        switch (edge) {
//                    case ALEdgeLeft:
//                        constraint = [[self leftAnchor] constraintEqualToAnchor:leftAnchor constant:inset];
//                        break;
//                    case ALEdgeRight:
//                        constraint = [[self rightAnchor] constraintEqualToAnchor:rightAnchor constant:inset];
//                        break;
//                    case ALEdgeTop:
//                        constraint = [[self topAnchor] constraintEqualToAnchor:topAnchor constant:inset];
//                        break;
//                    case ALEdgeBottom:
//                        constraint = [[self bottomAnchor] constraintEqualToAnchor:bottomAnchor constant:inset];
//                        break;
//                    case ALEdgeLeading:
//                        constraint = [[self leadingAnchor] constraintEqualToAnchor:leadingAnchor constant:inset];
//                        break;
//                    case ALEdgeTrailing:
//                        constraint = [[self trailingAnchor] constraintEqualToAnchor:trailingAnchor constant:inset];
//                        break;
//            }
//        constraint.active = YES;
//        return constraint;
    if (edge == ALEdgeBottom || edge == ALEdgeRight || edge == ALEdgeTrailing) {
        // The bottom, right, and trailing insets (and relations, if an inequality) are inverted to become offsets
        inset = -inset;
    }
        return  [self autoPinEdgeToSuperviewSafeArea:edge toEdge:edge withOffset:inset];
    }

/**
   Pins the edges of the view to the edges of its superview anchor.
 
   @return An array of constraints added, ordered counterclockwise from top.
   */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoPinEdgesToSuperviewSafeArea
{
        return [self autoPinEdgesToSuperviewSafeAreaWithInsets:ALEdgeInsetsZero];
    }

/**
   Pins the edges of the view to the edges of its superview anchor with the given edge insets.
   The insets.left corresponds to a leading edge constraint, and insets.right corresponds to a trailing edge constraint.
 
   @param insets The insets for this view's edges from its superview's edges.
   @return An array of constraints added, ordered counterclockwise from top.
   */
- (PL__NSArray_of(NSLayoutConstraint *) *)autoPinEdgesToSuperviewSafeAreaWithInsets:(ALEdgeInsets)insets
{
       __NSMutableArray_of(NSLayoutConstraint *) *constraints = [NSMutableArray new];
        [constraints addObject:[self autoPinEdgeToSuperviewSafeArea:ALEdgeTop withInset:insets.top]];
        [constraints addObject:[self autoPinEdgeToSuperviewSafeArea:ALEdgeLeading withInset:insets.left]];
        [constraints addObject:[self autoPinEdgeToSuperviewSafeArea:ALEdgeBottom withInset:insets.bottom]];
        [constraints addObject:[self autoPinEdgeToSuperviewSafeArea:ALEdgeTrailing withInset:insets.right]];
        return constraints;
}
- (PL__NSArray_of(NSLayoutConstraint *) *)autoPinEdgesToSuperviewSafeAreaWithInsets:(ALEdgeInsets)insets excludingEdge:(ALEdge)edge{
    __NSMutableArray_of(NSLayoutConstraint *) *constraints = [NSMutableArray new];
    if (edge != ALEdgeTop) {
        [constraints addObject:[self autoPinEdgeToSuperviewSafeArea:ALEdgeTop withInset:insets.top]];
    }
    if (edge != ALEdgeLeading && edge != ALEdgeLeft) {
        [constraints addObject:[self autoPinEdgeToSuperviewSafeArea:ALEdgeLeading withInset:insets.left]];
    }
    if (edge != ALEdgeBottom) {
        [constraints addObject:[self autoPinEdgeToSuperviewSafeArea:ALEdgeBottom withInset:insets.bottom]];
    }
    if (edge != ALEdgeTrailing && edge != ALEdgeRight) {
        [constraints addObject:[self autoPinEdgeToSuperviewSafeArea:ALEdgeTrailing withInset:insets.right]];
    }
    return constraints;
}

- (NSLayoutConstraint *)autoPinEdgeToSuperviewSafeArea:(ALEdge)edge toEdge:(ALEdge)toEdge{
    return [self autoPinEdgeToSuperviewSafeArea:edge toEdge:toEdge withOffset:0.0f];
}
- (NSLayoutConstraint *)autoPinEdgeToSuperviewSafeArea:(ALEdge)edge toEdge:(ALEdge)toEdge  withOffset:(CGFloat)offset{
    
    self.translatesAutoresizingMaskIntoConstraints = NO;
    
    ALView *superview = self.superview;
    NSLayoutConstraint *constraint = nil;
    
    NSLayoutYAxisAnchor *topAnchor;
    NSLayoutYAxisAnchor *bottomAnchor;
    NSLayoutXAxisAnchor *leftAnchor;
    NSLayoutXAxisAnchor *rightAnchor;
    NSLayoutXAxisAnchor *leadingAnchor;
    NSLayoutXAxisAnchor *trailingAnchor;
    if (@available(iOS 11.0, tvOS 11.0, *)) {
        topAnchor = superview.safeAreaLayoutGuide.topAnchor;
        bottomAnchor = superview.safeAreaLayoutGuide.bottomAnchor;
        leftAnchor = superview.safeAreaLayoutGuide.leftAnchor;
        rightAnchor = superview.safeAreaLayoutGuide.rightAnchor;
        leadingAnchor = superview.safeAreaLayoutGuide.leadingAnchor;
        trailingAnchor = superview.safeAreaLayoutGuide.trailingAnchor;
    } else {
        topAnchor = superview.topAnchor;
        bottomAnchor = superview.bottomAnchor;
        leftAnchor = superview.leftAnchor;
        rightAnchor = superview.rightAnchor;
        leadingAnchor = superview.leadingAnchor;
        trailingAnchor = superview.trailingAnchor;
    }
    
    NSLayoutXAxisAnchor *toAlignAnchor1 = nil;
    NSLayoutYAxisAnchor *toAlignAnchor2 = nil;
    switch (toEdge) {
        case ALEdgeLeft:
            toAlignAnchor1 = leftAnchor;
            break;
        case ALEdgeRight:
            toAlignAnchor1 = rightAnchor;
            break;
        case ALEdgeTop:
            toAlignAnchor2 = topAnchor;
            break;
        case ALEdgeBottom:
            toAlignAnchor2 = bottomAnchor;
            break;
        case ALEdgeLeading:
            toAlignAnchor1 = leadingAnchor;
            break;
        case ALEdgeTrailing:
            toAlignAnchor1 = trailingAnchor;
            break;
    }
    
    switch (edge) {
        case ALEdgeLeft:
            constraint = [[self leftAnchor] constraintEqualToAnchor:toAlignAnchor1 constant:offset];
            break;
        case ALEdgeRight:
            constraint = [[self rightAnchor] constraintEqualToAnchor:toAlignAnchor1 constant:offset];
            break;
        case ALEdgeTop:
            constraint = [[self topAnchor] constraintEqualToAnchor:toAlignAnchor2 constant:offset];
            break;
        case ALEdgeBottom:
            constraint = [[self bottomAnchor] constraintEqualToAnchor:toAlignAnchor2 constant:offset];
            break;
        case ALEdgeLeading:
            constraint = [[self leadingAnchor] constraintEqualToAnchor:toAlignAnchor1 constant:offset];
            break;
        case ALEdgeTrailing:
            constraint = [[self trailingAnchor] constraintEqualToAnchor:toAlignAnchor1 constant:offset];
            break;
    }
    constraint.active = YES;
    return constraint;
}
#endif /* PL__PureLayout_MinBaseSDK_iOS_8_0 */


@end
