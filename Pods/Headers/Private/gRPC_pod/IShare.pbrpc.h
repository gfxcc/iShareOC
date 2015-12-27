#import "IShare.pbobjc.h"

#import <ProtoRPC/ProtoService.h>
#import <RxLibrary/GRXWriteable.h>
#import <RxLibrary/GRXWriter.h>

#define ServerHost @"54.201.29.228:50051"

@protocol Greeter <NSObject>

#pragma mark SayHello(HelloRequest) returns (HelloReply)

- (void)sayHelloWithRequest:(HelloRequest *)request handler:(void(^)(HelloReply *response, NSError *error))handler;

- (ProtoRPC *)RPCToSayHelloWithRequest:(HelloRequest *)request handler:(void(^)(HelloReply *response, NSError *error))handler;


#pragma mark Login(Login_m) returns (Inf)

- (void)loginWithRequest:(Login_m *)request handler:(void(^)(Inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToLoginWithRequest:(Login_m *)request handler:(void(^)(Inf *response, NSError *error))handler;


#pragma mark Sign_up(Sign_m) returns (Inf)

- (void)sign_upWithRequest:(Sign_m *)request handler:(void(^)(Inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToSign_upWithRequest:(Sign_m *)request handler:(void(^)(Inf *response, NSError *error))handler;


#pragma mark User_inf(Inf) returns (User_detail)

- (void)user_infWithRequest:(Inf *)request handler:(void(^)(User_detail *response, NSError *error))handler;

- (ProtoRPC *)RPCToUser_infWithRequest:(Inf *)request handler:(void(^)(User_detail *response, NSError *error))handler;


#pragma mark Search_username(Inf) returns (Repeated_string)

- (void)search_usernameWithRequest:(Inf *)request handler:(void(^)(Repeated_string *response, NSError *error))handler;

- (ProtoRPC *)RPCToSearch_usernameWithRequest:(Inf *)request handler:(void(^)(Repeated_string *response, NSError *error))handler;


#pragma mark Add_friend(Repeated_string) returns (Inf)

- (void)add_friendWithRequest:(Repeated_string *)request handler:(void(^)(Inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToAdd_friendWithRequest:(Repeated_string *)request handler:(void(^)(Inf *response, NSError *error))handler;


#pragma mark Delete_friend(Repeated_string) returns (Inf)

- (void)delete_friendWithRequest:(Repeated_string *)request handler:(void(^)(Inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToDelete_friendWithRequest:(Repeated_string *)request handler:(void(^)(Inf *response, NSError *error))handler;


#pragma mark Create_share(Share_inf) returns (Inf)

- (void)create_shareWithRequest:(Share_inf *)request handler:(void(^)(Inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToCreate_shareWithRequest:(Share_inf *)request handler:(void(^)(Inf *response, NSError *error))handler;


#pragma mark Delete_bill(Share_inf) returns (Inf)

- (void)delete_billWithRequest:(Share_inf *)request handler:(void(^)(Inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToDelete_billWithRequest:(Share_inf *)request handler:(void(^)(Inf *response, NSError *error))handler;


#pragma mark Syn(stream Inf) returns (stream Syn_data)

- (void)synWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, Syn_data *response, NSError *error))eventHandler;

- (ProtoRPC *)RPCToSynWithRequestsWriter:(GRXWriter *)requestWriter eventHandler:(void(^)(BOOL done, Syn_data *response, NSError *error))eventHandler;


#pragma mark Obtain_bills(Bill_request) returns (stream Share_inf)

- (void)obtain_billsWithRequest:(Bill_request *)request eventHandler:(void(^)(BOOL done, Share_inf *response, NSError *error))eventHandler;

- (ProtoRPC *)RPCToObtain_billsWithRequest:(Bill_request *)request eventHandler:(void(^)(BOOL done, Share_inf *response, NSError *error))eventHandler;


#pragma mark Send_Img(stream Image) returns (Inf)

- (void)send_ImgWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(Inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToSend_ImgWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(Inf *response, NSError *error))handler;


#pragma mark Receive_Img(Repeated_string) returns (stream Image)

- (void)receive_ImgWithRequest:(Repeated_string *)request eventHandler:(void(^)(BOOL done, Image *response, NSError *error))eventHandler;

- (ProtoRPC *)RPCToReceive_ImgWithRequest:(Repeated_string *)request eventHandler:(void(^)(BOOL done, Image *response, NSError *error))eventHandler;


#pragma mark Reset_Status(Inf) returns (Inf)

- (void)reset_StatusWithRequest:(Inf *)request handler:(void(^)(Inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToReset_StatusWithRequest:(Inf *)request handler:(void(^)(Inf *response, NSError *error))handler;


#pragma mark Send_request(Request) returns (Inf)

- (void)send_requestWithRequest:(Request *)request handler:(void(^)(Inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToSend_requestWithRequest:(Request *)request handler:(void(^)(Inf *response, NSError *error))handler;


#pragma mark Obtain_request(Inf) returns (stream Request)

- (void)obtain_requestWithRequest:(Inf *)request eventHandler:(void(^)(BOOL done, Request *response, NSError *error))eventHandler;

- (ProtoRPC *)RPCToObtain_requestWithRequest:(Inf *)request eventHandler:(void(^)(BOOL done, Request *response, NSError *error))eventHandler;


#pragma mark Obtain_requestLog(Inf) returns (stream Request)

- (void)obtain_requestLogWithRequest:(Inf *)request eventHandler:(void(^)(BOOL done, Request *response, NSError *error))eventHandler;

- (ProtoRPC *)RPCToObtain_requestLogWithRequest:(Inf *)request eventHandler:(void(^)(BOOL done, Request *response, NSError *error))eventHandler;


#pragma mark Obtain_requestLogHistory(Inf) returns (stream Request)

- (void)obtain_requestLogHistoryWithRequest:(Inf *)request eventHandler:(void(^)(BOOL done, Request *response, NSError *error))eventHandler;

- (ProtoRPC *)RPCToObtain_requestLogHistoryWithRequest:(Inf *)request eventHandler:(void(^)(BOOL done, Request *response, NSError *error))eventHandler;


#pragma mark Request_response(Response) returns (Inf)

- (void)request_responseWithRequest:(Response *)request handler:(void(^)(Inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToRequest_responseWithRequest:(Response *)request handler:(void(^)(Inf *response, NSError *error))handler;


#pragma mark MakePayment(stream BillPayment) returns (Inf)

- (void)makePaymentWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(Inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToMakePaymentWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(Inf *response, NSError *error))handler;


#pragma mark IgnoreRequestLog(IgnoreMessage) returns (Inf)

- (void)ignoreRequestLogWithRequest:(IgnoreMessage *)request handler:(void(^)(Inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToIgnoreRequestLogWithRequest:(IgnoreMessage *)request handler:(void(^)(Inf *response, NSError *error))handler;


#pragma mark Create_requestLog(Request) returns (Inf)

- (void)create_requestLogWithRequest:(Request *)request handler:(void(^)(Inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToCreate_requestLogWithRequest:(Request *)request handler:(void(^)(Inf *response, NSError *error))handler;


#pragma mark Send_DeviceToken(Repeated_string) returns (Inf)

- (void)send_DeviceTokenWithRequest:(Repeated_string *)request handler:(void(^)(Inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToSend_DeviceTokenWithRequest:(Repeated_string *)request handler:(void(^)(Inf *response, NSError *error))handler;


@end

// Basic service implementation, over gRPC, that only does marshalling and parsing.
@interface Greeter : ProtoService<Greeter>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
@end
