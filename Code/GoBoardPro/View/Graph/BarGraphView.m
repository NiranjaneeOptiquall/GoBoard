//
//  BarGraphView.m
//  GoBoardPro
//
//  Created by ind558 on 11/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "BarGraphView.h"

@implementation BarGraphView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void)showStaticGraphWithValues :(NSArray *)myvalues andWithTitle :(NSArray *)myxtitle withColors:(NSArray*)colors groupTitle:(NSArray*)groupTitle
{
    horizontalLinesProperties=[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:25.0] forKey:@"gap"];
    anchorPropertiesArray=nil;
    verticalLinesProperties=nil;
    
//    NSArray *tempTitles = @[@"January", @"February", @"March"];
    xTitlesArray=[[NSArray alloc]initWithArray:groupTitle];
    
    xValuesArray=[[NSArray alloc]initWithArray:myxtitle];
    
    yValuesArray=[[NSArray alloc]initWithArray:myvalues];
    
    myBarChart=[[MIMBarGraph alloc]initWithFrame:CGRectMake(0, 20, self.frame.size.width, self.frame.size.height - 40)];
    NSMutableArray *mutArrColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        CGFloat red, green, blue, alpha;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        MIMColorClass *c1=[MIMColorClass colorWithRed:red Green:green Blue:blue Alpha:alpha];
        [mutArrColors addObject:c1];
    }
    myBarChart.barcolorArray = mutArrColors;
    myBarChart.delegate=self;
    myBarChart.barLabelStyle=BAR_LABEL_STYLE1;
    
// If Gradient is on than we need to pass double colors Light colors at starting indexes and dark colors at ending indexes eg if you have 3 bars to display than index 0-2 will be light colors for each bar and index 3-5 will be dark color for respective bars.
//    myBarChart.gradientStyle=VERTICAL_GRADIENT_STYLE;
    myBarChart.barGraphStyle=BAR_GRAPH_STYLE_GROUPED;
    myBarChart.xTitleStyle=XTitleStyle2;
    
    //Set the colors for multiple lines.
    
    
    [myBarChart drawBarChart];
    [self addSubview:myBarChart];
    
}

#pragma mark - BarGraph Delegate

-(NSArray *)valuesForGraph:(id)graph
{
    return yValuesArray;
}

-(NSArray *)valuesForXAxis:(id)graph
{
    return xValuesArray;
}


-(NSArray *)titlesForXAxis:(id)graph
{
    NSMutableArray *mutArr = [NSMutableArray array];
    for (int i = 0; i < [xValuesArray count]; i++) {
        NSMutableArray *mutA = [NSMutableArray array];
        for (int j = 0; j < [xValuesArray[i] count]; j++) {
            [mutA addObject:@""];
        }
        [mutArr addObject:mutA];
    }
    return mutArr;
//    NSArray *aTitleArray=[[NSArray alloc]initWithObjects:[NSArray arrayWithObjects:@"",@"",@"", nil],[NSArray arrayWithObjects:@"",@"",@"", nil],[NSArray arrayWithObjects: @"",@"",@"", nil], nil];

//    return aTitleArray;
    
}

-(NSArray *)grouptitlesForXAxis:(id)graph
{
    return xTitlesArray;
}

-(NSDictionary *)barProperties:(id)graph;
{
    NSDictionary *barProperty=[[NSDictionary alloc]initWithObjectsAndKeys:@"50",@"gapBetweenGroup" ,nil];//[[NSDictionary alloc]initWithObjectsAndKeys:@"6",@"gapBetweenBars",@"35",@"gapBetweenGroup", nil];
    return barProperty;
}

-(NSDictionary *)horizontalLinesProperties:(id)graph
{
    return [NSDictionary dictionaryWithObjectsAndKeys:@"1,4",@"dotted", nil];
}
-(UILabel *)createLabelWithText:(NSString *)text
{
    UILabel *a=[[UILabel alloc]initWithFrame:CGRectMake(5, self.frame.size.width * 0.5 + 20, 310, 20)];
    [a setBackgroundColor:[UIColor clearColor]];
    [a setText:text];
    a.numberOfLines=5;
    [a setTextAlignment:NSTextAlignmentCenter];
    [a setTextColor:[UIColor blackColor]];
    [a setFont:[UIFont fontWithName:@"Helvetica" size:12]];
    [a setMinimumScaleFactor:8/[UIFont labelFontSize]];
    return a;
    
}
-(NSDictionary *)xAxisProperties:(id)graph
{
    if([(MIMBarGraph *)graph tag]==12)
        return [NSDictionary dictionaryWithObjectsAndKeys:@"0.95,0.95,0.95",@"groupTitleBgColor", nil];
    
    return nil;
}

-(NSDictionary *)animationOnBars:(id)graph
{
    if([(MIMBarGraph *)graph tag]==10)
        return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:BAR_ANIMATION_VGROW_STYLE],[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.0], nil] forKeys:[NSArray arrayWithObjects:@"type",@"animationDelay",@"animationDuration" ,nil] ];
    else if([(MIMBarGraph *)graph tag]==13)
        return [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:[NSNumber numberWithInt:BAR_ANIMATION_VGROW_STYLE],[NSNumber numberWithFloat:1.0], nil] forKeys:[NSArray arrayWithObjects:@"type",@"animationDuration" ,nil] ];
    return nil;
}


@end
