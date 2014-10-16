//
//  BarGraphView.h
//  GoBoardPro
//
//  Created by ind558 on 11/10/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIMBarGraph.h"
#import "Constants.h"
#import "GraphView.h"

@interface BarGraphView : GraphView <BarGraphDelegate> {
    MIMBarGraph *myBarChart;
    NSArray *anchorPropertiesArray;
    NSDictionary *horizontalLinesProperties;
    NSDictionary *verticalLinesProperties;
    
    NSArray *yValuesArray;
    NSArray *xValuesArray;
    NSArray *xTitlesArray;
}

//-(void)showStaticGraphWithValues :(NSArray *)myvalues andWithTitle :(NSArray *)myxtitle withColors:(NSArray*)colors;
@end
