v0.4.0
=======

* Fixed Xcode auto-complete support ([nickynick](https://github.com/nickynick))

***Breaking Changes***

If you are holding onto any instances of masonry constraints ie
```obj-c
// in public/private interface
@property (nonatomic, strong) id<MASConstraint> topConstraint;
```

You will need to change this to
```obj-c
// in public/private interface
@property (nonatomic, strong) MASConstraint *topConstraint;
```

Instead of using protocols Masonry now uses an abstract base class for constraints in order to get Xcode auto-complete support see http://stackoverflow.com/questions/14534223/

v0.3.2
=======

* Add support for Mac OSX animator proxy ([pfandrade](https://github.com/pfandrade))

```objective-c
self.leftConstraint.animator.offset(20);
```

* Add setter methods for NSLayoutConstraint constant proxies like `offset`, `centerOffset`, `insets`, `sizeOffset`.
now you can update these values using more natural syntax

```objective-c
self.edgesConstraint.insets(UIEdgeInsetsMake(20, 10, 15, 5));
```

can now be written as:

```objective-c
self.edgesConstraint.insets = UIEdgeInsetsMake(20, 10, 15, 5);
```


v0.3.1
=======

* Add the same set of constraints to multiple views in an array ([danielrhammond](https://github.com/danielrhammond))

```objective-c
[@[view1, view2, view3] mas_makeConstraints:^(MASConstraintMaker *make) {
    make.baseline.equalTo(superView.mas_centerY);
    make.width.equalTo(@100);
}];
```

v0.3.0
=======

* added `- (NSArray *)mas_updateConstraints:(void(^)(MASConstraintMaker *))block` which will update existing constraints if possible, otherwise it will add them.  This makes it easier to use Masonry within the `UIView` `- (void)updateConstraints` method which is the recommended place for adding/updating constraints by apple.
* Updated examples for iOS7, added a few new examples.
* Added -isEqual: and -hash to MASViewAttribute [CraigSiemens].
