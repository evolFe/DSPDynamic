//
//  TspRouter.m
//  TSP_d
//
//  Created by evol on 2018/12/7.
//  Copyright © 2018 evol. All rights reserved.
//

#import "TspRouter.h"

@interface TspRouter ()
{
    int N;//点的个数
    double x[20];
    double y[20];
    double dp[20][20];//两个城市的距离
    double dis[1048577][20];//2^20=1048576 表示出发点到S集合是否已经访问过
    double path[1048577][20];
}

@end

@implementation TspRouter

- (double)goWithS:(int)s init:(int)init{
    if(dis[s][init]!=-1) return dis[s][init];//去重
    if(s==(1<<(N-1))){
        return dp[N-1][init];//只有最后一个点返回
    }
    double minlen=100000;
    int index = 0;
    for(int i=0;i<N-1;i++)//只能在1到n-2点中查找
    {
        if(s&(1<<i))//如果i点在s中且不为发出点
        {
            int next = s&(~(1<<i));
            double temp = [self goWithS:next init:i];
            if(temp+dp[i][init]<minlen) {
                minlen=temp+dp[i][init];
                index = i;
            }
        }
    }
    path[s][init] = index;
    return dis[s][init]=minlen;
}

- (NSArray *)cities {
    NSString * jsonPath=[[NSBundle mainBundle] pathForResource:@"city" ofType:@"json"];
    if(jsonPath == nil)
        return nil;
    
    NSData *valueOfJson=[[NSData alloc] initWithContentsOfFile:jsonPath];
    NSError *error = nil;
    
    id instance = [NSJSONSerialization JSONObjectWithData:valueOfJson options:NSJSONReadingMutableLeaves error:&error];
    if (error)
    {
        NSLog(@"解析错误");
        return nil;
    }
    return instance;
}

- (NSArray *)caculate {
    NSArray * cs = self.cities;
    N = (int)cs.count;
    for(int i=0;i<N;i++){
        NSDictionary * dictItem = cs[i];
        x[i] = [dictItem[@"X"] doubleValue];
        y[i] = [dictItem[@"Y"] doubleValue];
    }
    for(int i=0;i<N;i++)
        for(int j=0;j<N;j++)
        {
            dp[i][j]=sqrt(pow((x[i]-x[j]),2)+pow((y[i]-y[j]),2));
            //计算两个城市的距离
        }
    
    for(int i=0;i<pow(2,N);i++)
        for(int j=0;j<N;j++)
            dis[i][j]=-1;//去重数组初始化
    int s = 0;
    for(int i=1; i<N; i++)
        s = s|(1<<i);//从1开始，保证初始点没有在S里面
    double distance=[self goWithS:s init:0];
    int index = 0;
    //        int result = 0;
    NSMutableArray * arr = [NSMutableArray arrayWithObject:@0];
    for (int i = 0; i < N; i++) {
        index = path[s][index];
        if (index == 0) break;
        [arr addObject:@(index)];
        s = s&(~(1<<index));
        NSLog(@"index:%@",@(index));
    }
    [arr addObject:@9];
    NSLog(@"distance : %@",@(distance));
    return arr;
}

@end
