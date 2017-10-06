//
//  LoginCell.m
//  HackerNews
//
//  Created by akshay bansal on 9/20/17.
//  Copyright © 2017 akshay bansal. All rights reserved.
//

#import "LoginCell.h"
#import "CustomTextField.h"
#import "NSUserDefaults+Helper.h"
#import "Constants.h"
@import Firebase;
@import GoogleSignIn;


@interface LoginCell()<UITextFieldDelegate,GIDSignInUIDelegate>
{
    UIImageView *logoImageView;
    CustomTextField *mobileTextFiled;
    CustomTextField *passwordTextField;
    UIButton *loginButton;

}

@property (nonatomic, strong) UIView *overlayView;
@property (nonatomic, strong) UIActivityIndicatorView *activityIndicator;


@end


@implementation LoginCell

-(instancetype)initWithFrame:(CGRect)frame
{
    
    self=[super initWithFrame:frame];
    
    if (self) {
        [self setupViews];
    }
    

    return self;
}


-(void)setupViews{

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginSucess:) name:LoginSucess object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(errorWhileLogingIN:) name:LoginFailed object:nil];
    
    
    /*-tapGesture-*/
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    [self addGestureRecognizer:tap];
    
    
    /*--loginAPI setup--*/
  
    
    
    /*--Loding View --*/
    self.overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.overlayView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    self.activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.activityIndicator.center = self.overlayView.center;
    [self.overlayView addSubview:self.activityIndicator];
    
    
    /*--setting up views--*/
    logoImageView=[[UIImageView alloc] init];
    [logoImageView setImage:[UIImage imageNamed:@"logo"]];
    logoImageView.contentMode=UIViewContentModeScaleAspectFit;
    logoImageView.translatesAutoresizingMaskIntoConstraints=false;
    [self addSubview:logoImageView];

    
    mobileTextFiled=[[CustomTextField alloc] init];
    mobileTextFiled.translatesAutoresizingMaskIntoConstraints=false;
    mobileTextFiled.placeholder=@"Enter Mobile No.";
    mobileTextFiled.layer.borderColor=[UIColor lightGrayColor].CGColor;
    mobileTextFiled.layer.borderWidth=1;
    mobileTextFiled.keyboardType=UIKeyboardTypeEmailAddress;
    mobileTextFiled.translatesAutoresizingMaskIntoConstraints=false;
    UIImageView *mobileTextFiledUserView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mobile"]];
    mobileTextFiled.leftView = mobileTextFiledUserView;
    mobileTextFiled.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *mobileTextFiledErrorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [mobileTextFiledErrorView setImage:[UIImage imageNamed:@"error"]];
    mobileTextFiledErrorView.contentMode=UIViewContentModeScaleAspectFit;
    mobileTextFiled.rightView = mobileTextFiledErrorView;
    mobileTextFiled.rightViewMode = UITextFieldViewModeAlways;
    mobileTextFiled.rightView.hidden=true;
    [self addSubview:mobileTextFiled];
    
    if ( [[NSUserDefaults standardUserDefaults] getUserEmail]) {
        mobileTextFiled.text=[[NSUserDefaults standardUserDefaults] getUserEmail];
    }
    

    passwordTextField=[[CustomTextField alloc] init];
    passwordTextField.translatesAutoresizingMaskIntoConstraints=false;
    passwordTextField.placeholder=@"Enter Password";
    passwordTextField.layer.borderColor=[UIColor lightGrayColor].CGColor;
    passwordTextField.layer.borderWidth=1;
    passwordTextField.keyboardType=UIKeyboardTypeASCIICapable;
    passwordTextField.secureTextEntry=true;
    passwordTextField.translatesAutoresizingMaskIntoConstraints=false;
    UIImageView *passwordTextFieldView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"password"]];
    passwordTextField.leftView = passwordTextFieldView;
    passwordTextField.leftViewMode = UITextFieldViewModeAlways;
    UIImageView *passwordTextFieldErrorView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    [passwordTextFieldErrorView setImage:[UIImage imageNamed:@"error"]];
    passwordTextFieldErrorView.contentMode=UIViewContentModeScaleAspectFit;
    passwordTextField.rightView = passwordTextFieldErrorView;
    passwordTextField.rightViewMode = UITextFieldViewModeAlways;
    passwordTextField.rightView.hidden=true;
    [self addSubview:passwordTextField];
    if ( [[NSUserDefaults standardUserDefaults] getUserPassword]) {
        passwordTextField.text=[[NSUserDefaults standardUserDefaults] getUserPassword];
    }
    
    
    loginButton=[[UIButton alloc] initWithFrame:CGRectZero];
    [loginButton setTitle:@"Log In" forState:UIControlStateNormal];
    loginButton.backgroundColor=[UIColor colorWithRed:247.0/255.0 green:154.0/255.0 blue:27.0/255.0   alpha:1];
    loginButton.translatesAutoresizingMaskIntoConstraints=false;
    [loginButton addTarget:self action:@selector(handleLogin) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:loginButton];
    
    
    
    
    
    [logoImageView.topAnchor constraintEqualToAnchor:self.centerYAnchor constant:-230].active=YES;
    [logoImageView.centerXAnchor constraintEqualToAnchor:self.centerXAnchor].active=YES;
    //[logoImageView.widthAnchor constraintEqualToConstant:240].active=YES;
    [logoImageView.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:32].active=YES;
    [logoImageView.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-32].active=YES;
    [logoImageView.heightAnchor constraintEqualToConstant:160].active=YES;
    
    [mobileTextFiled.topAnchor constraintEqualToAnchor:logoImageView.bottomAnchor constant:8].active=YES;
    [mobileTextFiled.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:32].active=YES;
    [mobileTextFiled.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-32].active=YES;
    [mobileTextFiled.heightAnchor constraintEqualToConstant:50].active=YES;
    
    
    [passwordTextField.topAnchor constraintEqualToAnchor:mobileTextFiled.bottomAnchor constant:8].active=YES;
    [passwordTextField.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:32].active=YES;
    [passwordTextField.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-32].active=YES;
    [passwordTextField.heightAnchor constraintEqualToConstant:50].active=YES;
    
    
    
    [loginButton.topAnchor constraintEqualToAnchor:passwordTextField.bottomAnchor constant:16].active=YES;
    [loginButton.leftAnchor constraintEqualToAnchor:self.leftAnchor constant:32].active=YES;
    [loginButton.rightAnchor constraintEqualToAnchor:self.rightAnchor constant:-32].active=YES;
    [loginButton.heightAnchor constraintEqualToConstant:50].active=YES;
    
}




-(void)loginSucess:(NSNotification *) notification{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
         [self.delegate finishLoggingIn];
    });
    
    
}

-(void)errorWhileLogingIN:(NSNotification *) notification{
    
    NSDictionary* userInfo = notification.userInfo;
    NSString* msg = (NSString*)userInfo[@"msg"];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self stopActivityIndicator];
        [self showError:msg];
    });
    
    
}


- (void)handleSingleTap:(UITapGestureRecognizer *)sender
{
    [self endEditing:YES];
}



-(void)handleLogin{
    
    [self startActivityIndicator];
    [[GIDSignIn sharedInstance] signIn];
    return;
    
    
    
    [self endEditing:YES];
    
    if (![self isValidContactNo:mobileTextFiled.text]) {
        [self showError:@"Please enter valid Mobile Number"];
        mobileTextFiled.rightView.hidden=false;
        passwordTextField.rightView.hidden=false;
        return;
    }
    else if (passwordTextField.text.length<4) {
        [self showError:@"Please enter valid password"];
        mobileTextFiled.rightView.hidden=true;
        passwordTextField.rightView.hidden=false;
        return;
    }
    else
    {
        mobileTextFiled.rightView.hidden=true;
        passwordTextField.rightView.hidden=true;
        
        /*--saving the last user entered details--*/
        [[NSUserDefaults standardUserDefaults] setUserEmail:mobileTextFiled.text];
        [[NSUserDefaults standardUserDefaults] setUserPassword:passwordTextField.text];
        
      // [self startActivityIndicator];
      //  [loginApi loginWithEmail:emailTextField.text password:passwordTextField.text ssos:@"0"];
    
    
    }

}



-(BOOL)isValidContactNo:(NSString *)ContactNo
{
    NSString *stricterFilterString = @"[0-9]{7,13}$";
    NSPredicate *conatactTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", stricterFilterString];
    return [conatactTest evaluateWithObject:ContactNo];
}



-(void)showError:(NSString *)msg
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];

}

-(void) startActivityIndicator{
    

    [self.activityIndicator startAnimating];
    [self addSubview:self.overlayView];
    
}

-(void) stopActivityIndicator{
    
    [self.activityIndicator stopAnimating];
    [self.overlayView removeFromSuperview];
    
    
}




@end
