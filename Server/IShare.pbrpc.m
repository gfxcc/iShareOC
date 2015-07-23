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
@end
