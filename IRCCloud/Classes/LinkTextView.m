//
//  LinkTextView.m
//
//  Copyright (C) 2016 IRCCloud, Ltd.
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//  http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.

#import "LinkTextView.h"

NSTextStorage *__LinkTextViewTextStorage;
NSTextContainer *__LinkTextViewTextContainer;
NSLayoutManager *__LinkTextViewLayoutManager;

@implementation LinkTextView

- (id)init {
    return [self initWithFrame:CGRectZero];
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        _links = [[NSMutableArray alloc] init];
        _tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [self addGestureRecognizer:_tapGesture];
    }
    return self;
}

- (void)viewTapped:(UITapGestureRecognizer *)sender {
    if(_linkDelegate && sender.state == UIGestureRecognizerStateEnded) {
        NSTextCheckingResult *r = [self linkAtPoint:[sender locationInView:self]];
        if(r) {
            [_linkDelegate LinkTextView:self didSelectLinkWithTextCheckingResult:r];
        } else {
            UIView *obj = self;
            
            do {
                obj = obj.superview;
            } while (obj && ![obj isKindOfClass:[UITableViewCell class]]);
            if(obj) {
                UITableViewCell *cell = (UITableViewCell*)obj;
                
                do {
                    obj = obj.superview;
                } while (![obj isKindOfClass:[UITableView class]]);
                UITableView *tableView = (UITableView*)obj;
                
                NSIndexPath *indePath = [tableView indexPathForCell:cell];
                [[tableView delegate] tableView:tableView didSelectRowAtIndexPath:indePath];
            }
        }
    }
}

- (void)addLinkToURL:(NSURL *)url withRange:(NSRange)range {
    [self addLinkWithTextCheckingResult:[NSTextCheckingResult linkCheckingResultWithRange:range URL:url]];
}

- (void)addLinkWithTextCheckingResult:(NSTextCheckingResult *)result {
    [_links addObject:result];
    [self.textStorage addAttributes:self.linkAttributes range:result.range];
}

- (NSTextCheckingResult *)linkAtPoint:(CGPoint)p {
    UITextRange *textRange = [self characterRangeAtPoint:p];
    NSUInteger start = [self offsetFromPosition:self.beginningOfDocument toPosition:textRange.start];
    
    for(NSTextCheckingResult *r in _links) {
        if(start >= r.range.location && start < r.range.location + r.range.length)
            return r;
    }
    return nil;
}

-(void)setText:(NSString *)text {
    [_links removeAllObjects];
    [super setText:text];
}

-(void)setAttributedText:(NSAttributedString *)attributedText {
    [_links removeAllObjects];
    [super setAttributedText:attributedText];
}

+(CGFloat)heightOfString:(NSAttributedString *)text constrainedToWidth:(CGFloat)width {
    if(!__LinkTextViewTextStorage) {
        __LinkTextViewTextStorage = [[NSTextStorage alloc] init];
        __LinkTextViewLayoutManager = [[NSLayoutManager alloc] init];
        [__LinkTextViewTextStorage addLayoutManager:__LinkTextViewLayoutManager];
        __LinkTextViewTextContainer = [[NSTextContainer alloc] initWithSize:CGSizeZero];
        __LinkTextViewTextContainer.lineFragmentPadding = 0;
        __LinkTextViewTextContainer.lineBreakMode = NSLineBreakByWordWrapping;
        [__LinkTextViewLayoutManager addTextContainer:__LinkTextViewTextContainer];
    }
    @synchronized (__LinkTextViewTextStorage) {
        __LinkTextViewTextContainer.size = CGSizeMake(width, CGFLOAT_MAX);
        [__LinkTextViewTextStorage setAttributedString:text];
        (void) [__LinkTextViewLayoutManager glyphRangeForTextContainer:__LinkTextViewTextContainer];
        return [__LinkTextViewLayoutManager usedRectForTextContainer:__LinkTextViewTextContainer].size.height;
    }
}

@end
