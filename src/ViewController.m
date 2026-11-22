#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *startPauseButton;
@property (nonatomic, strong) UIButton *resetButton;
@property (nonatomic, strong) CADisplayLink *displayLink;
@property (nonatomic, assign) CFTimeInterval startTime;
@property (nonatomic, assign) CFTimeInterval pausedElapsed;
@property (nonatomic, assign) BOOL isRunning;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor systemBackgroundColor];
    self.title = @"Stopwatch";
    
    [self setupUI];
    [self updateTimeLabel:0];
}

- (void)setupUI {
    // Time label
    self.timeLabel = [[UILabel alloc] init];
    self.timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    self.timeLabel.font = [UIFont monospacedDigitSystemFontOfSize:64 weight:UIFontWeightMedium];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = [UIColor labelColor];
    [self.view addSubview:self.timeLabel];
    
    // Start/Pause button
    self.startPauseButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.startPauseButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.startPauseButton setTitle:@"Start" forState:UIControlStateNormal];
    self.startPauseButton.titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
    [self.startPauseButton addTarget:self action:@selector(startPauseTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.startPauseButton.backgroundColor = [UIColor systemGreenColor];
    [self.startPauseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.startPauseButton.layer.cornerRadius = 12;
    [self.view addSubview:self.startPauseButton];
    
    // Reset button
    self.resetButton = [UIButton buttonWithType:UIButtonTypeSystem];
    self.resetButton.translatesAutoresizingMaskIntoConstraints = NO;
    [self.resetButton setTitle:@"Reset" forState:UIControlStateNormal];
    self.resetButton.titleLabel.font = [UIFont systemFontOfSize:24 weight:UIFontWeightSemibold];
    [self.resetButton addTarget:self action:@selector(resetTapped:) forControlEvents:UIControlEventTouchUpInside];
    self.resetButton.backgroundColor = [UIColor systemRedColor];
    [self.resetButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.resetButton.layer.cornerRadius = 12;
    [self.view addSubview:self.resetButton];
    
    UILayoutGuide *safeArea = self.view.safeAreaLayoutGuide;
    
    [NSLayoutConstraint activateConstraints:@[
        // Time label centered
        [self.timeLabel.centerXAnchor constraintEqualToAnchor:safeArea.centerXAnchor],
        [self.timeLabel.centerYAnchor constraintEqualToAnchor:safeArea.centerYAnchor, constant:-60],
        [self.timeLabel.leadingAnchor constraintGreaterThanOrEqualToAnchor:safeArea.leadingAnchor constant:20],
        [self.timeLabel.trailingAnchor constraintLessThanOrEqualToAnchor:safeArea.trailingAnchor constant:-20],
        
        // Start/Pause button
        [self.startPauseButton.topAnchor constraintEqualToAnchor:self.timeLabel.bottomAnchor constant:40],
        [self.startPauseButton.centerXAnchor constraintEqualToAnchor:safeArea.centerXAnchor, constant:-90],
        [self.startPauseButton.widthAnchor constraintEqualToConstant:140],
        [self.startPauseButton.heightAnchor constraintEqualToConstant:56],
        
        // Reset button
        [self.resetButton.topAnchor constraintEqualToAnchor:self.timeLabel.bottomAnchor constant:40],
        [self.resetButton.centerXAnchor constraintEqualToAnchor:safeArea.centerXAnchor, constant:90],
        [self.resetButton.widthAnchor constraintEqualToConstant:140],
        [self.resetButton.heightAnchor constraintEqualToConstant:56],
    ]];
}

- (void)startPauseTapped:(UIButton *)sender {
    if (self.isRunning) {
        [self pause];
    } else {
        [self start];
    }
}

- (void)start {
    self.startTime = CACurrentMediaTime() - self.pausedElapsed;
    self.displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateTimer:)];
    [self.displayLink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
    self.isRunning = YES;
    [self.startPauseButton setTitle:@"Pause" forState:UIControlStateNormal];
    self.startPauseButton.backgroundColor = [UIColor systemOrangeColor];
}

- (void)pause {
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.pausedElapsed = CACurrentMediaTime() - self.startTime;
    self.isRunning = NO;
    [self.startPauseButton setTitle:@"Start" forState:UIControlStateNormal];
    self.startPauseButton.backgroundColor = [UIColor systemGreenColor];
}

- (void)resetTapped:(UIButton *)sender {
    [self.displayLink invalidate];
    self.displayLink = nil;
    self.startTime = 0;
    self.pausedElapsed = 0;
    self.isRunning = NO;
    [self updateTimeLabel:0];
    [self.startPauseButton setTitle:@"Start" forState:UIControlStateNormal];
    self.startPauseButton.backgroundColor = [UIColor systemGreenColor];
}

- (void)updateTimer:(CADisplayLink *)displayLink {
    CFTimeInterval elapsed = CACurrentMediaTime() - self.startTime;
    [self updateTimeLabel:elapsed];
}

- (void)updateTimeLabel:(CFTimeInterval)elapsed {
    long long totalMilliseconds = (long long)(elapsed * 1000);
    long long hours = totalMilliseconds / 3600000;
    long long minutes = (totalMilliseconds % 3600000) / 60000;
    long long seconds = (totalMilliseconds % 60000) / 1000;
    long long milliseconds = totalMilliseconds % 1000;
    
    self.timeLabel.text = [NSString stringWithFormat:@"%02lld:%02lld:%02lld.%03lld", hours, minutes, seconds, milliseconds];
}

@end