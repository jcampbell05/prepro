//
//  PPDocumentViewController.m
//  Prepro
//
//  Created by James Campbell on 30/01/2014.
//  Copyright (c) 2014 Dean Uzzell. All rights reserved.
//

#import "PPDocumentViewController.h"
#import "UIViewController+PPPanel.h"
#import "LIExposeController.h"
#import "MBAlertView.h"
#import "Masonry.h"
#import "PPAppStyle.h"
#import "PPAppStyleManager.h"

const NSString * exposeNotification = @"expose";
const NSString * documentListNotification = @"document";

@interface PPDocumentViewController ()

- (void)createTitleView;
- (void)createViewSelector;

- (void)createExposeBarButton;
- (void)createDocumentListBarButton;

- (void)attachSingleTapRecognizer;
- (void)attachTitleViewDoubleTapGesture;

- (void)switchToView:(PPDocumentView *)documentView;
- (void)viewSelected:(UISegmentedControl *)segment;

- (void)switchViewController:(UIViewController *)viewController;
- (void)willSwitchToDocumentView:(PPDocumentView *)documentView;
- (void)didSwitchToDocumentView:(PPDocumentView *)documentView;

- (BOOL)isTitleValid;
- (void)showEnterTitleAlert;
    
- (void)exposePressed;
- (void)documentListPressed;

@end

@implementation PPDocumentViewController

#pragma mark - UIViewController Lifecycle

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
    
    [self createExposeBarButton];
    [self createDocumentListBarButton];
    
    self.navigationItem.rightBarButtonItems = @[_exposeButton, _documentListButton];
    
    if ( _views.count > 0 ) {
        [self setSelectedView: 0];
    }

}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [self.navigationController setToolbarHidden:NO animated:animated];
    [self.navigationController.toolbar setTranslucent: NO];
    
    self.navigationController.toolbar.barTintColor = [UIColor whiteColor];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self save];
    
    [self.navigationController setToolbarHidden:YES animated:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear: animated];
    
    [self attachTitleViewDoubleTapGesture];
}

#pragma mark - PPDocumentViewController Implementation

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
    _titleTextField.textColor = [UIColor blackColor];
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
    
    [_viewSelector addTarget:self action:@selector(viewSelected:) forControlEvents:UIControlEventValueChanged];
    
    PPAppStyle * appStyle = [[PPAppStyleManager sharedInstance] appStyle];
    _viewSelector.tintColor = appStyle.primaryColour;
    
    UIBarButtonItem * spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem * viewPickerWrapper = [[UIBarButtonItem alloc] initWithCustomView: _viewSelector];
    
    self.toolbarItems = @[spacer, viewPickerWrapper, spacer];
}

- (void)createExposeBarButton {
    
    _exposeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"Expose"] style:UIBarButtonItemStylePlain target:self action:@selector(exposePressed)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(exposePressed) name:exposeNotification object:nil];
}

- (void)createDocumentListBarButton {
    
    _documentListButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"List View"]  style:UIBarButtonItemStylePlain target:self action:@selector(documentListPressed)];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(documentListPressed) name:documentListNotification object:nil];
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
    
- (void)exposePressed {
    [self.exposeController toggleExpose];
}

- (void)documentListPressed {
    [self.panelController hidePanelViewController];
}

#pragma mark - Events

- (void)viewSelected:(UISegmentedControl *)segment {
    self.selectedView = segment.selectedSegmentIndex;
}

#pragma mark - UITextFieldDelegate

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
