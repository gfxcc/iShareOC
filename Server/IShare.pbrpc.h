#import "IShare.pbobjc.h"
#import <gRPC/ProtoRPC/ProtoService.h>

#define ServerHost @"http://192.168.0.103:50051"

@protocol GRXWriteable;
@protocol GRXWriter;

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


#pragma mark Syn(stream Inf) returns (stream Syn_data)

- (void)synWithRequestsWriter:(id<GRXWriter>)request handler:(void(^)(BOOL done, Syn_data *response, NSError *error))handler;

- (ProtoRPC *)RPCToSynWithRequestsWriter:(id<GRXWriter>)request handler:(void(^)(BOOL done, Syn_data *response, NSError *error))handler;


#pragma mark Obtain_bills(Bill_request) returns (stream Share_inf)

- (void)obtain_billsWithRequest:(Bill_request *)request handler:(void(^)(BOOL done, Share_inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToObtain_billsWithRequest:(Bill_request *)request handler:(void(^)(BOOL done, Share_inf *response, NSError *error))handler;


#pragma mark Send_Img(stream Image) returns (Inf)

- (void)send_ImgWithRequestsWriter:(id<GRXWriter>)request handler:(void(^)(Inf *response, NSError *error))handler;

- (ProtoRPC *)RPCToSend_ImgWithRequestsWriter:(id<GRXWriter>)request handler:(void(^)(Inf *response, NSError *error))handler;


#pragma mark Receive_Img(Repeated_string) returns (stream Image)

- (void)receive_ImgWithRequest:(Repeated_string *)request handler:(void(^)(BOOL done, Image *response, NSError *error))handler;

- (ProtoRPC *)RPCToReceive_ImgWithRequest:(Repeated_string *)request handler:(void(^)(BOOL done, Image *response, NSError *error))handler;


@end

// Basic service implementation, over gRPC, that only does marshalling and parsing.
@interface Greeter : ProtoService<Greeter>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
@end
