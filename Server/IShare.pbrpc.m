#import "IShare.pbrpc.h"
#import <gRPC/RxLibrary/GRXWriteable.h>
#import <gRPC/RxLibrary/GRXWriter+Immediate.h>
#import <gRPC/ProtoRPC/ProtoRPC.h>

static NSString *const kPackageName = @"helloworld";
static NSString *const kServiceName = @"Greeter";

@implementation Greeter

// Designated initializer
- (instancetype)initWithHost:(NSString *)host {
  return (self = [super initWithHost:host packageName:kPackageName serviceName:kServiceName]);
}

// Override superclass initializer to disallow different package and service names.
- (instancetype)initWithHost:(NSString *)host
                 packageName:(NSString *)packageName
                 serviceName:(NSString *)serviceName {
  return [self initWithHost:host];
}


#pragma mark SayHello(HelloRequest) returns (HelloReply)

- (void)sayHelloWithRequest:(HelloRequest *)request handler:(void(^)(HelloReply *response, NSError *error))handler{
  [[self RPCToSayHelloWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToSayHelloWithRequest:(HelloRequest *)request handler:(void(^)(HelloReply *response, NSError *error))handler{
  return [self RPCToMethod:@"SayHello"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[HelloReply class]
        responsesWriteable:[GRXWriteable writeableWithSingleValueHandler:handler]];
}
#pragma mark Login(Login_m) returns (Inf)

- (void)loginWithRequest:(Login_m *)request handler:(void(^)(Inf *response, NSError *error))handler{
  [[self RPCToLoginWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToLoginWithRequest:(Login_m *)request handler:(void(^)(Inf *response, NSError *error))handler{
  return [self RPCToMethod:@"Login"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Inf class]
        responsesWriteable:[GRXWriteable writeableWithSingleValueHandler:handler]];
}
#pragma mark Sign_up(Sign_m) returns (Inf)

- (void)sign_upWithRequest:(Sign_m *)request handler:(void(^)(Inf *response, NSError *error))handler{
  [[self RPCToSign_upWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToSign_upWithRequest:(Sign_m *)request handler:(void(^)(Inf *response, NSError *error))handler{
  return [self RPCToMethod:@"Sign_up"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Inf class]
        responsesWriteable:[GRXWriteable writeableWithSingleValueHandler:handler]];
}
#pragma mark User_inf(Inf) returns (User_detail)

- (void)user_infWithRequest:(Inf *)request handler:(void(^)(User_detail *response, NSError *error))handler{
  [[self RPCToUser_infWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToUser_infWithRequest:(Inf *)request handler:(void(^)(User_detail *response, NSError *error))handler{
  return [self RPCToMethod:@"User_inf"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[User_detail class]
        responsesWriteable:[GRXWriteable writeableWithSingleValueHandler:handler]];
}
#pragma mark Search_username(Inf) returns (Repeated_string)

- (void)search_usernameWithRequest:(Inf *)request handler:(void(^)(Repeated_string *response, NSError *error))handler{
  [[self RPCToSearch_usernameWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToSearch_usernameWithRequest:(Inf *)request handler:(void(^)(Repeated_string *response, NSError *error))handler{
  return [self RPCToMethod:@"Search_username"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Repeated_string class]
        responsesWriteable:[GRXWriteable writeableWithSingleValueHandler:handler]];
}
#pragma mark Add_friend(Repeated_string) returns (Inf)

- (void)add_friendWithRequest:(Repeated_string *)request handler:(void(^)(Inf *response, NSError *error))handler{
  [[self RPCToAdd_friendWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToAdd_friendWithRequest:(Repeated_string *)request handler:(void(^)(Inf *response, NSError *error))handler{
  return [self RPCToMethod:@"Add_friend"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Inf class]
        responsesWriteable:[GRXWriteable writeableWithSingleValueHandler:handler]];
}
#pragma mark Delete_friend(Repeated_string) returns (Inf)

- (void)delete_friendWithRequest:(Repeated_string *)request handler:(void(^)(Inf *response, NSError *error))handler{
  [[self RPCToDelete_friendWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToDelete_friendWithRequest:(Repeated_string *)request handler:(void(^)(Inf *response, NSError *error))handler{
  return [self RPCToMethod:@"Delete_friend"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Inf class]
        responsesWriteable:[GRXWriteable writeableWithSingleValueHandler:handler]];
}
#pragma mark Create_share(Share_inf) returns (Inf)

- (void)create_shareWithRequest:(Share_inf *)request handler:(void(^)(Inf *response, NSError *error))handler{
  [[self RPCToCreate_shareWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToCreate_shareWithRequest:(Share_inf *)request handler:(void(^)(Inf *response, NSError *error))handler{
  return [self RPCToMethod:@"Create_share"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Inf class]
        responsesWriteable:[GRXWriteable writeableWithSingleValueHandler:handler]];
}
#pragma mark Syn(stream Inf) returns (stream Syn_data)

- (void)synWithRequestsWriter:(id<GRXWriter>)request handler:(void(^)(BOOL done, Syn_data *response, NSError *error))handler{
  [[self RPCToSynWithRequestsWriter:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToSynWithRequestsWriter:(id<GRXWriter>)request handler:(void(^)(BOOL done, Syn_data *response, NSError *error))handler{
  return [self RPCToMethod:@"Syn"
            requestsWriter:request
             responseClass:[Syn_data class]
        responsesWriteable:[GRXWriteable writeableWithStreamHandler:handler]];
}
#pragma mark Obtain_bills(Bill_request) returns (stream Share_inf)

- (void)obtain_billsWithRequest:(Bill_request *)request handler:(void(^)(BOOL done, Share_inf *response, NSError *error))handler{
  [[self RPCToObtain_billsWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToObtain_billsWithRequest:(Bill_request *)request handler:(void(^)(BOOL done, Share_inf *response, NSError *error))handler{
  return [self RPCToMethod:@"Obtain_bills"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Share_inf class]
        responsesWriteable:[GRXWriteable writeableWithStreamHandler:handler]];
}
#pragma mark Send_Img(stream Image) returns (Inf)

- (void)send_ImgWithRequestsWriter:(id<GRXWriter>)request handler:(void(^)(Inf *response, NSError *error))handler{
  [[self RPCToSend_ImgWithRequestsWriter:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToSend_ImgWithRequestsWriter:(id<GRXWriter>)request handler:(void(^)(Inf *response, NSError *error))handler{
  return [self RPCToMethod:@"Send_Img"
            requestsWriter:request
             responseClass:[Inf class]
        responsesWriteable:[GRXWriteable writeableWithSingleValueHandler:handler]];
}
#pragma mark Receive_Img(Repeated_string) returns (stream Image)

- (void)receive_ImgWithRequest:(Repeated_string *)request handler:(void(^)(BOOL done, Image *response, NSError *error))handler{
  [[self RPCToReceive_ImgWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToReceive_ImgWithRequest:(Repeated_string *)request handler:(void(^)(BOOL done, Image *response, NSError *error))handler{
  return [self RPCToMethod:@"Receive_Img"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Image class]
        responsesWriteable:[GRXWriteable writeableWithStreamHandler:handler]];
}
#pragma mark Reset_Status(Inf) returns (Inf)

- (void)reset_StatusWithRequest:(Inf *)request handler:(void(^)(Inf *response, NSError *error))handler{
  [[self RPCToReset_StatusWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToReset_StatusWithRequest:(Inf *)request handler:(void(^)(Inf *response, NSError *error))handler{
  return [self RPCToMethod:@"Reset_Status"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Inf class]
        responsesWriteable:[GRXWriteable writeableWithSingleValueHandler:handler]];
}
#pragma mark Send_request(Request) returns (Inf)

- (void)send_requestWithRequest:(Request *)request handler:(void(^)(Inf *response, NSError *error))handler{
  [[self RPCToSend_requestWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToSend_requestWithRequest:(Request *)request handler:(void(^)(Inf *response, NSError *error))handler{
  return [self RPCToMethod:@"Send_request"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Inf class]
        responsesWriteable:[GRXWriteable writeableWithSingleValueHandler:handler]];
}
#pragma mark Obtain_request(Inf) returns (stream Request)

- (void)obtain_requestWithRequest:(Inf *)request handler:(void(^)(BOOL done, Request *response, NSError *error))handler{
  [[self RPCToObtain_requestWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToObtain_requestWithRequest:(Inf *)request handler:(void(^)(BOOL done, Request *response, NSError *error))handler{
  return [self RPCToMethod:@"Obtain_request"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Request class]
        responsesWriteable:[GRXWriteable writeableWithStreamHandler:handler]];
}
#pragma mark Obtain_requestLog(Inf) returns (stream Request)

- (void)obtain_requestLogWithRequest:(Inf *)request handler:(void(^)(BOOL done, Request *response, NSError *error))handler{
  [[self RPCToObtain_requestLogWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToObtain_requestLogWithRequest:(Inf *)request handler:(void(^)(BOOL done, Request *response, NSError *error))handler{
  return [self RPCToMethod:@"Obtain_requestLog"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Request class]
        responsesWriteable:[GRXWriteable writeableWithStreamHandler:handler]];
}
#pragma mark Obtain_requestLogHistory(Inf) returns (stream Request)

- (void)obtain_requestLogHistoryWithRequest:(Inf *)request handler:(void(^)(BOOL done, Request *response, NSError *error))handler{
  [[self RPCToObtain_requestLogHistoryWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToObtain_requestLogHistoryWithRequest:(Inf *)request handler:(void(^)(BOOL done, Request *response, NSError *error))handler{
  return [self RPCToMethod:@"Obtain_requestLogHistory"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Request class]
        responsesWriteable:[GRXWriteable writeableWithStreamHandler:handler]];
}
#pragma mark Request_response(Response) returns (Inf)

- (void)request_responseWithRequest:(Response *)request handler:(void(^)(Inf *response, NSError *error))handler{
  [[self RPCToRequest_responseWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToRequest_responseWithRequest:(Response *)request handler:(void(^)(Inf *response, NSError *error))handler{
  return [self RPCToMethod:@"Request_response"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Inf class]
        responsesWriteable:[GRXWriteable writeableWithSingleValueHandler:handler]];
}
#pragma mark MakePayment(stream BillPayment) returns (Inf)

- (void)makePaymentWithRequestsWriter:(id<GRXWriter>)request handler:(void(^)(Inf *response, NSError *error))handler{
  [[self RPCToMakePaymentWithRequestsWriter:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToMakePaymentWithRequestsWriter:(id<GRXWriter>)request handler:(void(^)(Inf *response, NSError *error))handler{
  return [self RPCToMethod:@"MakePayment"
            requestsWriter:request
             responseClass:[Inf class]
        responsesWriteable:[GRXWriteable writeableWithSingleValueHandler:handler]];
}
#pragma mark IgnoreRequestLog(IgnoreMessage) returns (Inf)

- (void)ignoreRequestLogWithRequest:(IgnoreMessage *)request handler:(void(^)(Inf *response, NSError *error))handler{
  [[self RPCToIgnoreRequestLogWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToIgnoreRequestLogWithRequest:(IgnoreMessage *)request handler:(void(^)(Inf *response, NSError *error))handler{
  return [self RPCToMethod:@"IgnoreRequestLog"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Inf class]
        responsesWriteable:[GRXWriteable writeableWithSingleValueHandler:handler]];
}
#pragma mark Create_requestLog(Request) returns (Inf)

- (void)create_requestLogWithRequest:(Request *)request handler:(void(^)(Inf *response, NSError *error))handler{
  [[self RPCToCreate_requestLogWithRequest:request handler:handler] start];
}
// Returns a not-yet-started RPC object.
- (ProtoRPC *)RPCToCreate_requestLogWithRequest:(Request *)request handler:(void(^)(Inf *response, NSError *error))handler{
  return [self RPCToMethod:@"Create_requestLog"
            requestsWriter:[GRXWriter writerWithValue:request]
             responseClass:[Inf class]
        responsesWriteable:[GRXWriteable writeableWithSingleValueHandler:handler]];
}
@end
