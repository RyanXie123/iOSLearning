//
//  ViewController.m
//  UIWebView
//
//  Created by 谢汝 on 2018/2/6.
//  Copyright © 2018年 谢汝. All rights reserved.
//

#import "ViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property(nonatomic,strong)JSContext *context;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
//    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.5.147.34:63342/tt1/index.html?_ijt=m8renmjlgpm7ompq9ggsq876g1"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:[[NSBundle mainBundle]URLForResource:@"index.html" withExtension:nil]];
    
    self.webView.delegate = self;
//    [self.webView loadHTMLString:@"<a href=\"darkangel://smsLogin?username=12323123&code=892845\">短信验证登录</a>" baseURL:nil];
    [self.webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

//    self.navigationItem.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    /**
     问题:  OC 如何调用JS方法
     方法1：stringByEvaluatingJavaScriptFromString
     
     该方法不能判断调用了一个js方法之后，是否发生了错误。当错误发生时，返回值为nil，而当调用一个方法本身没有返回值时，返回值也为nil，所以无法判断是否调用成功了。
     返回值类型为nullable NSString *，就意味着当调用的js方法有返回值时，都以字符串返回，不够灵活。当返回值是一个js的Array时，还需要解析字符串，比较麻烦。
     
     方法2：JavaScriptCore
     */
    
    JSContext *jsContext = [self.webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    self.context = jsContext;
    [jsContext setExceptionHandler:^(JSContext *context, JSValue *exception) {
        NSLog(@"%@  exception",exception);
    }];
    JSValue *value = [jsContext evaluateScript:@"document.title"];
    self.navigationItem.title = value.toString;
    
    
    

    /**
     JS调用OC
     1.JavaScriptCore（iOS 7.0 +）
     
     self.jsContext[@"yourMethodName"] = your block;这样写不仅可以在有yourMethodName方法时替换该JS方法为OC实现，还会在该方法没有时，添加方法。简而言之，有则替换，无则添加。
     
     
     
     */
//    self.context[@"share"] = ^(){
//        NSArray *args = [JSContext currentArguments];
//        NSMutableArray *msgs = [NSMutableArray array];
//        for (JSValue *obj in args) {
//            [msgs addObject:[obj toObject]];
//        }
//        NSLog(@"点击分享js传回的参数： \n%@",msgs);
//    };

    
    
    //异步回调
    self.context[@"share2"] = ^(JSValue *shareData) {  //首先这里要注意，回调的参数不能直接写NSDictionary类型，为何呢？
        //仔细看，打印出的确实是一个NSDictionary，但是result字段对应的不是block而是一个NSDictionary
        NSLog(@"%@", [shareData toObject]);
        id obj = [shareData toObject];
        //获取shareData对象的result属性，这个JSValue对应的其实是一个javascript的function。
        JSValue *resultFunction = [shareData valueForProperty:@"result"];
        //回调block，将js的function转换为OC的block
        void (^result)(BOOL) = ^(BOOL isSuccess) {
            [resultFunction callWithArguments:@[@(isSuccess)]];
        };
        //模拟异步回调
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSLog(@"回调分享成功");
            result(YES);
        });
    };
    
    
//    self.context[@"testAddMethod"] = ^NSInteger(NSInteger a, NSInteger b) {
//        return a + b;
//    };
//
//    [self.context evaluateScript:@"alert(testAddMethod(1, 5)); "];
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    /**
      JS调用OC
        1. Custom URL Scheme（拦截URL）
     
     优点：泛用性强，可以配合h5实现页面动态化。比如页面中一个活动链接到活动详情页，当native尚未开发完毕时，链接可以是一个h5链接，等到native开发完毕时，可以通过该方法跳转到native页面，实现页面动态化。且该方案适用于Android和iOS，泛用性很强。
     
     缺点：无法直接获取本次交互的返回值，比较适合单向传参，且不关心回调的情景，比如h5页面跳转到native页面等。
     
        2. JavaScriptCore
     
     
     
     */
    NSURL *url = request.URL;
    if ([url.scheme isEqualToString:@"darkangel"]) {
        if ([url.host isEqualToString:@"smsLogin"]) {
            NSLog(@"短信验证码登录，参数为 %@",url.query);
            return NO;
        }
    }
    
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
