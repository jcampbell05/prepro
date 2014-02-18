//
//  PPDocumentViewController.m
//  Prepro
//
//  Created by James Campbell on 30/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPDocumentViewController.h"
#import "MBAlertView.h"
#import "Masonry.h"

@interface PPDocumentViewController ()

- (void)createTitleView;
- (void)createViewSelector;
- (void)attachSingleTapRecognizer;
- (void)attachTitleViewDoubleTapGesture;

- (void)switchToView:(PPDocumentView *)documentView;
- (void)viewSelected:(UISegmentedControl *)segment;
- (void)switchViewController:(UIViewController *)viewController;

- (BOOL)isTitleValid;
- (void)showEnterTitleAlert;

@end

@implementation PPDocumentViewController

#pragma mark UIViewController Lifecycle

- (id)init {
    
    if ( self = [super initWithNibName:nil bundle:nil] ) {
        _isTitleDoubleTapToEditGestureEnabled = YES;
    }
    
    return self;
}

- (void)loadView
{
    self.view = [[UIView alloc] init];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self loadDocumentViews];
    
    [self createTitleView];
    [self createViewSelector];
    
    if ( _views.count > 0 ) {
        [self setSelectedView: 0];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [self save];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear: animated];
    
    [self attachTitleViewDoubleTapGesture];
}

#pragma mark PPDocumentViewController Implementation

- (void)setSelectedView:(NSUInteger)selectedView {
    
    _currentView = [self.views objectAtIndex: selectedView];
    _viewSelector.selectedSegmentIndex = selectedView;
    
    [self switchToView: _currentView];
}

- (NSUInteger)selectedView {
    
    return [self.views indexOfObject: _currentView];
}

- (void)setTitle:(NSString *)title {
    _titleTextField.text = title;
}

- (NSString *)title {
    return _titleTextField.text;
}

- (void)setIsTitleDoubleTapToEditGestureEnabled:(BOOL)isTitleDoubleTapToEditGestureEnabled {
    _titleDoubleTapGestureRecognizer.enabled = _isTitleDoubleTapToEditGestureEnabled;
}

- (void)loadDocumentViews {
    
}

- (void)startEditingTitle {
    
    [self attachSingleTapRecognizer];
    
    _titleTextField.enabled  = YES;
    _singleTapRecognizer.enabled = YES;
    
    [_titleTextField becomeFirstResponder];
}

- (void)endEditingTitle {
    [_titleTextField resignFirstResponder];
}

- (void)willSwitchToDocumentView:(PPDocumentView *)documentView {
    
}

- (void)didSwitchToDocumentView:(PPDocumentView *)documentView {
    
}

- (void)save {
    
}

- (void)createTitleView {
    
    _titleTextField = [[UITextField alloc] initWithFrame:CGRectMake(37,7, 100,35)];
    _titleTextField.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _titleTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _titleTextField.backgroundColor = [UIColor clearColor];
    _titleTextField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    _titleTextField.delegate = self;
    _titleTextField.enabled  = NO;
    _titleTextField.font = [UIFont systemFontOfSize:20.0];
    _titleTextField.opaque = NO;
    _titleTextField.textAlignment = NSTextAlignmentCenter;
    _titleTextField.textColor = [UIColor whiteColor];
    _titleTextField.returnKeyType = UIReturnKeyDone;
    _titleTextField.adjustsFontSizeToFitWidth = YES;
    
    self.navigationItem.titleView = _titleTextField;
}

- (void)createViewSelector {
    
    NSMutableArray * viewSelectorItems = [[NSMutableArray alloc] init];
    
    [self.views enumerateObjectsUsingBlock:^(PPDocumentView * documentView, NSUInteger idx, BOOL *stop) {
        
        [viewSelectorItems addObject: documentView.title];
    }];
    
    _viewSelector = [[UISegmentedControl alloc] initWithItems: viewSelectorItems];
    _viewSelector.segmentedControlStyle = UISegmentedControlStyleBar;
    
    [_viewSelector addTarget:self action:@selector(viewSelected:) forControlEvents:UIControlEventValueChanged];
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        _viewSelector.tintColor = [UIColor whiteColor];
    }
    
    UIBarButtonItem * spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * viewPickerWrapper = [[UIBarButtonItem alloc] initWithCustomView: _viewSelector];
    
    self.toolbarItems = @[spacer, viewPickerWrapper, spacer];
}

- (void)attachSingleTapRecognizer {
    
    if ( _singleTapRecognizer != nil) {
        _singleTapRecognizer = nil;
    }
    
    _singleTapRecognizer = [[UITapGestureRecognizer alloc] init];
    _singleTapRecognizer.enabled = NO;
    _singleTapRecognizer.numberOfTapsRequired = 1;
    
    [_singleTapRecognizer addTarget:self action:@selector(endEditingTitle)];
    [self.view addGestureRecognizer:_singleTapRecognizer];
}

- (void)attachTitleViewDoubleTapGesture {
    
    if ( _titleDoubleTapGestureRecognizer != nil) {
        _titleDoubleTapGestureRecognizer = nil;
    }
    
    _titleDoubleTapGestureRecognizer = [[UITapGestureRecognizer alloc] init];
    _titleDoubleTapGestureRecognizer.enabled = _isTitleDoubleTapToEditGestureEnabled;
    _titleDoubleTapGestureRecognizer.numberOfTapsRequired = 2;
    
    [_titleDoubleTapGestureRecognizer addTarget:self action:@selector(startEditingTitle)];
    [_titleTextField addGestureRecognizer:_titleDoubleTapGestureRecognizer];
}

- (void)switchToView:(PPDocumentView *)documentView {
    
    [self willSwitchToDocumentView: documentView];
    
    [self switchViewController: documentView.viewController];
    
    [self didSwitchToDocumentView: documentView];
}

- (void)switchViewController:(UIViewController *)viewController {
    if ( _currentViewController ) {

        [_currentViewController.view removeFromSuperview];
        [_currentViewController removeFromParentViewController];

        _currentViewController = nil;
    }

    [self addChildViewController: viewController];
    [self.view addSubview: viewController.view];
    
    [viewController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];

    [viewController didMoveToParentViewController:self];
    _currentViewController = viewController;
}

- (BOOL)isTitleValid {
    return (_titleTextField.text.length > 0);
}

- (void)showEnterTitleAlert {
    [[MBAlertView alertWithBody:@"Please enter a title" cancelTitle:@"Continue" cancelBlock:^{
        [self startEditingTitle];
    }] addToDisplayQueue];
}

#pragma mark Events

- (void)viewSelected:(UISegmentedControl *)segment {
    self.selectedView = segment.selectedSegmentIndex;
}

#pragma mark UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if ( [string isEqualToString:@"\n"] ) {
        
        [self endEditingTitle];
        
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    
    if ( ![self isTitleValid] ) {
        [self showEnterTitleAlert];
    }
    
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField == _titleTextField ) {
        
        _titleTextField.enabled = NO;
        _singleTapRecognizer.enabled = NO;
        
        [self attachTitleViewDoubleTapGesture];
        [self save];
    }
    
}

@end
