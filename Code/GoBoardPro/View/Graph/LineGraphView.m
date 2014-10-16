//
//  LineGraphView.m
//  GoBoardPro
//
//  Created by ind558 on 11/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import "LineGraphView.h"

@implementation LineGraphView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)showStaticGraphWithValues :(NSArray *)myvalues andWithTitle :(NSArray *)myxtitle withColors:(NSArray*)colors
{
    horizontalLinesProperties=[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:40.0] forKey:@"gap"];
    anchorPropertiesArray=nil;
    verticalLinesProperties=nil;
    
    xTitlesArray=[[NSArray alloc]initWithArray:myxtitle];
    
    xValuesArray=[[NSArray alloc]initWithArray:myxtitle];
    
    yValuesArray=[[NSArray alloc]initWithArray:myvalues];
    
    mLineGraph=[[MIMLineGraph alloc]initWithFrame:CGRectMake(5, 40, self.frame.size.width-10, self.frame.size.height)];
    mLineGraph.delegate=self;
    mLineGraph.tag=1;
    
    //Set the colors for multiple lines.
    NSMutableArray *mutArrColors = [NSMutableArray array];
    for (UIColor *color in colors) {
        CGFloat red, green, blue, alpha;
//        float red, green, blue, alpha;
        [color getRed:&red green:&green blue:&blue alpha:&alpha];
        MIMColorClass *c1=[MIMColorClass colorWithRed:red Green:green Blue:blue Alpha:alpha];
        [mutArrColors addObject:c1];
    }
    
    mLineGraph.lineColorArray=mutArrColors;
    
    [mLineGraph drawMIMLineGraph];
    [self addSubview:mLineGraph];
}

#pragma mark - DELEGATE METHODS

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
    return xTitlesArray;
}

-(NSArray *)AnchorProperties:(id)graph
{
    return anchorPropertiesArray;
}

-(NSDictionary *)horizontalLinesProperties:(id)graph
{
    return horizontalLinesProperties;
}

-(NSDictionary*)verticalLinesProperties:(id)graph
{
    return verticalLinesProperties;
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
    [a setMinimumScaleFactor:0.5];
    return a;
}

@end
