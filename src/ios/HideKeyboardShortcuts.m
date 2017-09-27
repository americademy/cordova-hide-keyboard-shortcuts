// Copyright 2017 Americademy, Inc
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#import "HideKeyboardShortcuts.h"
#import <Cordova/CDVPlugin.h>
#import <objc/runtime.h>

@implementation HideKeyboardShortcuts

- (void) hideKeyboardShortcutBar: (UIView *)view
{
  for (UIView *sub in view.subviews) {
    [self hideKeyboardShortcutBar:sub];
    NSString *className = NSStringFromClass([sub class]);
    if ([className isEqualToString:@"WKContentView"] || [className isEqualToString:@"UIWebBrowserView"]) {

      Method method = class_getInstanceMethod(sub.class, @selector(inputAccessoryView));
      IMP newImp = imp_implementationWithBlock(^(id _s) {
        if ([sub respondsToSelector:@selector(inputAssistantItem)]) {
          UITextInputAssistantItem *inputAssistantItem = [sub inputAssistantItem];
          inputAssistantItem.leadingBarButtonGroups = @[];
          inputAssistantItem.trailingBarButtonGroups = @[];
        }
        return nil;
      });
      method_setImplementation(method, newImp);
    }
  }
}

- (void) pluginInitialize
{
    [self hideKeyboardShortcutBar:self.webView];
}

@end
