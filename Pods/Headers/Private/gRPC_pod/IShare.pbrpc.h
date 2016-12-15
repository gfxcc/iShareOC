#import "IShare.pbobjc.h"

#import <ProtoRPC/ProtoService.h>
#import <RxLibrary/GRXWriteable.h>
#import <RxLibrary/GRXWriter.h>

#define ServerHost @"54.201.29.228:50053"

NS_ASSUME_NONNULL_BEGIN

@protocol Synchronism <NSObject>

#pragma mark Syn(Inf) returns (stream Syn_data)

/**
 * do no need update
 * A server-to-client streaming RPC
 * 
 * start after terminal finish basic work. keep synchronism with S
 * input    User.username
 * output   User.synchronism<friend, bill, delete, request>
 */
- (void)synWithRequest:(Inf *)request eventHandler:(void(^)(BOOL done, Syn_data *_Nullable response, NSError *_Nullable error))eventHandler;

/**
 * do no need update
 * A server-to-client streaming RPC
 * 
 * start after terminal finish basic work. keep synchronism with S
 * input    User.username
 * output   User.synchronism<friend, bill, delete, request>
 */
- (GRPCProtoCall *)RPCToSynWithRequest:(Inf *)request eventHandler:(void(^)(BOOL done, Syn_data *_Nullable response, NSError *_Nullable error))eventHandler;


@end

/**
 * Basic service implementation, over gRPC, that only does
 * marshalling and parsing.
 */
@interface Synchronism : GRPCProtoService<Synchronism>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end
@protocol Greeter <NSObject>

#pragma mark SayHello(HelloRequest) returns (HelloReply)

/**
 * Sends a greeting
 */
- (void)sayHelloWithRequest:(HelloRequest *)request handler:(void(^)(HelloReply *_Nullable response, NSError *_Nullable error))handler;

/**
 * Sends a greeting
 */
- (GRPCProtoCall *)RPCToSayHelloWithRequest:(HelloRequest *)request handler:(void(^)(HelloReply *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Login(Login_m) returns (Reply_inf)

/**
 * 
 * 
 * 
 * rpc TimeTest (Inf) returns (stream Inf) {}
 * 
 * updated
 * A simple RPC
 * login_m(usename, password)
 * Reply_inf(status, information) : status(CANCALLED, OK) : information(reason why CANCALLED or user_id);
 * replye->information can be used as notice
 * login rpc
 */
- (void)loginWithRequest:(Login_m *)request handler:(void(^)(Reply_inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * 
 * 
 * 
 * rpc TimeTest (Inf) returns (stream Inf) {}
 * 
 * updated
 * A simple RPC
 * login_m(usename, password)
 * Reply_inf(status, information) : status(CANCALLED, OK) : information(reason why CANCALLED or user_id);
 * replye->information can be used as notice
 * login rpc
 */
- (GRPCProtoCall *)RPCToLoginWithRequest:(Login_m *)request handler:(void(^)(Reply_inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Sign_up(Sign_m) returns (Reply_inf)

/**
 * updated
 * A simple RPC
 * sign_m(username, password, email)
 * Reply_inf(status, information) : status(CANCALLED, OK) : information(reason why CANCALLED or user_id);
 * sign in rpc
 */
- (void)sign_upWithRequest:(Sign_m *)request handler:(void(^)(Reply_inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * updated
 * A simple RPC
 * sign_m(username, password, email)
 * Reply_inf(status, information) : status(CANCALLED, OK) : information(reason why CANCALLED or user_id);
 * sign in rpc
 */
- (GRPCProtoCall *)RPCToSign_upWithRequest:(Sign_m *)request handler:(void(^)(Reply_inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark User_inf(Inf) returns (User_detail)

/**
 * updated
 * A simple RPC
 * 
 * input    user_id
 * output   username, user_id, email, friends_name, friends_id
 */
- (void)user_infWithRequest:(Inf *)request handler:(void(^)(User_detail *_Nullable response, NSError *_Nullable error))handler;

/**
 * updated
 * A simple RPC
 * 
 * input    user_id
 * output   username, user_id, email, friends_name, friends_id
 */
- (GRPCProtoCall *)RPCToUser_infWithRequest:(Inf *)request handler:(void(^)(User_detail *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Search_username(Inf) returns (Search_result)

/**
 * do not need update
 * 
 * A simple RPC
 * 
 * search user by username
 */
- (void)search_usernameWithRequest:(Inf *)request handler:(void(^)(Search_result *_Nullable response, NSError *_Nullable error))handler;

/**
 * do not need update
 * 
 * A simple RPC
 * 
 * search user by username
 */
- (GRPCProtoCall *)RPCToSearch_usernameWithRequest:(Inf *)request handler:(void(^)(Search_result *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Add_friend(Repeated_string) returns (Inf)

/**
 * updated
 * A simple RPC
 * input username
 * 
 * add new friend
 */
- (void)add_friendWithRequest:(Repeated_string *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * updated
 * A simple RPC
 * input username
 * 
 * add new friend
 */
- (GRPCProtoCall *)RPCToAdd_friendWithRequest:(Repeated_string *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Delete_friend(Repeated_string) returns (Inf)

/**
 * updated
 * A simple RPC
 * input user_id
 * 
 * delete a friend
 */
- (void)delete_friendWithRequest:(Repeated_string *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * updated
 * A simple RPC
 * input user_id
 * 
 * delete a friend
 */
- (GRPCProtoCall *)RPCToDelete_friendWithRequest:(Repeated_string *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Create_share(Share_inf) returns (Inf)

/**
 * updated
 * A simple RPC
 * 
 * create a new share record
 */
- (void)create_shareWithRequest:(Share_inf *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * updated
 * A simple RPC
 * 
 * create a new share record
 */
- (GRPCProtoCall *)RPCToCreate_shareWithRequest:(Share_inf *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Delete_bill(Share_inf) returns (Inf)

/**
 * updated
 * delete a bill
 * 
 * use bill_id to identify bill record
 */
- (void)delete_billWithRequest:(Share_inf *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * updated
 * delete a bill
 * 
 * use bill_id to identify bill record
 */
- (GRPCProtoCall *)RPCToDelete_billWithRequest:(Share_inf *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Obtain_bills(Bill_request) returns (stream Share_inf)

/**
 * updated
 * 
 * 
 * input username amount(??? / all)
 * output Bills()
 */
- (void)obtain_billsWithRequest:(Bill_request *)request eventHandler:(void(^)(BOOL done, Share_inf *_Nullable response, NSError *_Nullable error))eventHandler;

/**
 * updated
 * 
 * 
 * input username amount(??? / all)
 * output Bills()
 */
- (GRPCProtoCall *)RPCToObtain_billsWithRequest:(Bill_request *)request eventHandler:(void(^)(BOOL done, Share_inf *_Nullable response, NSError *_Nullable error))eventHandler;


#pragma mark Send_Img(stream Image) returns (Inf)

/**
 * do not need to update
 * 
 * 
 * input Three byte package imageNmae, imagePath, imageData
 * output "Get image"
 */
- (void)send_ImgWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * do not need to update
 * 
 * 
 * input Three byte package imageNmae, imagePath, imageData
 * output "Get image"
 */
- (GRPCProtoCall *)RPCToSend_ImgWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Receive_Img(Repeated_string) returns (stream Image)

/**
 * do not need update
 * 
 * 
 * input folderName - imageName - imageName -.........
 * outut Image bytes package filled data and name
 */
- (void)receive_ImgWithRequest:(Repeated_string *)request eventHandler:(void(^)(BOOL done, Image *_Nullable response, NSError *_Nullable error))eventHandler;

/**
 * do not need update
 * 
 * 
 * input folderName - imageName - imageName -.........
 * outut Image bytes package filled data and name
 */
- (GRPCProtoCall *)RPCToReceive_ImgWithRequest:(Repeated_string *)request eventHandler:(void(^)(BOOL done, Image *_Nullable response, NSError *_Nullable error))eventHandler;


#pragma mark Reset_Status(Inf) returns (Inf)

/**
 * updated
 * set user synchronism_delete = 0
 * 
 * 
 */
- (void)reset_StatusWithRequest:(Inf *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * updated
 * set user synchronism_delete = 0
 * 
 * 
 */
- (GRPCProtoCall *)RPCToReset_StatusWithRequest:(Inf *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Send_request(Request) returns (Inf)

/**
 * updated
 * # request system rpc
 * send request. add friend or payment
 * enum-type : friendInvite, payment
 * from, to use username rather than userID
 * content formate SENDER:%@ RECEVER:%@ FIRSTID:%@ LASTID:%@ COUNT:%ld
 * sender or receiver is uername
 */
- (void)send_requestWithRequest:(Request *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * updated
 * # request system rpc
 * send request. add friend or payment
 * enum-type : friendInvite, payment
 * from, to use username rather than userID
 * content formate SENDER:%@ RECEVER:%@ FIRSTID:%@ LASTID:%@ COUNT:%ld
 * sender or receiver is uername
 */
- (GRPCProtoCall *)RPCToSend_requestWithRequest:(Request *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Obtain_request(Inf) returns (stream Request)

/**
 * updated
 * Inf contain user_id
 * 
 * 
 */
- (void)obtain_requestWithRequest:(Inf *)request eventHandler:(void(^)(BOOL done, Request *_Nullable response, NSError *_Nullable error))eventHandler;

/**
 * updated
 * Inf contain user_id
 * 
 * 
 */
- (GRPCProtoCall *)RPCToObtain_requestWithRequest:(Inf *)request eventHandler:(void(^)(BOOL done, Request *_Nullable response, NSError *_Nullable error))eventHandler;


#pragma mark Obtain_requestLog(Inf) returns (stream Request)

/**
 * updated
 * return requestLog has not been read
 * 
 * 
 */
- (void)obtain_requestLogWithRequest:(Inf *)request eventHandler:(void(^)(BOOL done, Request *_Nullable response, NSError *_Nullable error))eventHandler;

/**
 * updated
 * return requestLog has not been read
 * 
 * 
 */
- (GRPCProtoCall *)RPCToObtain_requestLogWithRequest:(Inf *)request eventHandler:(void(^)(BOOL done, Request *_Nullable response, NSError *_Nullable error))eventHandler;


#pragma mark Obtain_requestLogHistory(Inf) returns (stream Request)

/**
 * updated
 * return all requestLog
 * 
 * 
 */
- (void)obtain_requestLogHistoryWithRequest:(Inf *)request eventHandler:(void(^)(BOOL done, Request *_Nullable response, NSError *_Nullable error))eventHandler;

/**
 * updated
 * return all requestLog
 * 
 * 
 */
- (GRPCProtoCall *)RPCToObtain_requestLogHistoryWithRequest:(Inf *)request eventHandler:(void(^)(BOOL done, Request *_Nullable response, NSError *_Nullable error))eventHandler;


#pragma mark Request_response(Response) returns (Inf)

/**
 * updated
 * 
 * 
 * 
 */
- (void)request_responseWithRequest:(Response *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * updated
 * 
 * 
 * 
 */
- (GRPCProtoCall *)RPCToRequest_responseWithRequest:(Response *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark MakePayment(stream BillPayment) returns (Inf)

/**
 * do not nedd update
 * 
 * 
 * 
 */
- (void)makePaymentWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * do not nedd update
 * 
 * 
 * 
 */
- (GRPCProtoCall *)RPCToMakePaymentWithRequestsWriter:(GRXWriter *)requestWriter handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark IgnoreRequestLog(IgnoreMessage) returns (Inf)

/**
 * updated
 * 
 * 
 * 
 */
- (void)ignoreRequestLogWithRequest:(IgnoreMessage *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * updated
 * 
 * 
 * 
 */
- (GRPCProtoCall *)RPCToIgnoreRequestLogWithRequest:(IgnoreMessage *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Create_requestLog(Request) returns (Inf)

/**
 * 
 * 
 * 
 */
- (void)create_requestLogWithRequest:(Request *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * 
 * 
 * 
 */
- (GRPCProtoCall *)RPCToCreate_requestLogWithRequest:(Request *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Send_DeviceToken(Repeated_string) returns (Inf)

/**
 * updated
 * 
 * 
 * 
 */
- (void)send_DeviceTokenWithRequest:(Repeated_string *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * updated
 * 
 * 
 * 
 */
- (GRPCProtoCall *)RPCToSend_DeviceTokenWithRequest:(Repeated_string *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Obtain_setting(Inf) returns (Setting)

/**
 * send username
 * 
 * 
 */
- (void)obtain_settingWithRequest:(Inf *)request handler:(void(^)(Setting *_Nullable response, NSError *_Nullable error))handler;

/**
 * send username
 * 
 * 
 */
- (GRPCProtoCall *)RPCToObtain_settingWithRequest:(Inf *)request handler:(void(^)(Setting *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Reset_setting(Setting) returns (Inf)

/**
 * 
 * 
 * 
 */
- (void)reset_settingWithRequest:(Setting *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * 
 * 
 * 
 */
- (GRPCProtoCall *)RPCToReset_settingWithRequest:(Setting *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Reset_userInfo(UserInfo) returns (Inf)

/**
 * 
 * 
 * 
 */
- (void)reset_userInfoWithRequest:(UserInfo *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * 
 * 
 * 
 */
- (GRPCProtoCall *)RPCToReset_userInfoWithRequest:(UserInfo *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Obtain_userInfo(Inf) returns (UserInfo)

/**
 * 
 * 
 * 
 */
- (void)obtain_userInfoWithRequest:(Inf *)request handler:(void(^)(UserInfo *_Nullable response, NSError *_Nullable error))handler;

/**
 * 
 * 
 * 
 */
- (GRPCProtoCall *)RPCToObtain_userInfoWithRequest:(Inf *)request handler:(void(^)(UserInfo *_Nullable response, NSError *_Nullable error))handler;


#pragma mark Update_user_lastModified(Inf) returns (Inf)

/**
 * 
 * 
 * 
 */
- (void)update_user_lastModifiedWithRequest:(Inf *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;

/**
 * 
 * 
 * 
 */
- (GRPCProtoCall *)RPCToUpdate_user_lastModifiedWithRequest:(Inf *)request handler:(void(^)(Inf *_Nullable response, NSError *_Nullable error))handler;


@end

/**
 * Basic service implementation, over gRPC, that only does
 * marshalling and parsing.
 */
@interface Greeter : GRPCProtoService<Greeter>
- (instancetype)initWithHost:(NSString *)host NS_DESIGNATED_INITIALIZER;
+ (instancetype)serviceWithHost:(NSString *)host;
@end

NS_ASSUME_NONNULL_END
