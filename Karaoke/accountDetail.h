//
//  accountDetail.h
//  Karaoke
//
//  Created by Krishna_Mac_3 on 23/04/14.
//  Copyright (c) 2014 Krishna_Mac_3. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface accountDetail : NSObject
@property (nonatomic, copy) NSString *Status;
@property (nonatomic, copy) NSString *StatusDetail;
@property (nonatomic, copy) NSString *VPSTxId;
@property (nonatomic, copy) NSString *SecurityKey;
@property (nonatomic, copy) NSString *TxAuthNo;
@property (nonatomic, copy) NSString *AVSCV2;
@property (nonatomic, copy) NSString *AddressResult;
@property (nonatomic, copy) NSString *PostCodeResult;
@property (nonatomic, copy) NSString *CV2Result;
@property (nonatomic, copy) NSString *SecureStatus;
@property (nonatomic, copy) NSString *FraudResponse;
@property (nonatomic, copy) NSString *ExpiryDate;
@property (nonatomic, copy) NSString *BankAuthCode;
@property (nonatomic, copy) NSString *DeclineCode;

@end
