// Generated by the gRPC protobuf plugin.
// If you make any local change, they will be lost.
// source: iShare.proto

#include "iShare.pb.h"
#include "iShare.grpc.pb.h"

#include <grpc++/async_unary_call.h>
#include <grpc++/channel_interface.h>
#include <grpc++/impl/client_unary_call.h>
#include <grpc++/impl/rpc_service_method.h>
#include <grpc++/impl/service_type.h>
#include <grpc++/stream.h>
namespace helloworld {

static const char* Greeter_method_names[] = {
  "/helloworld.Greeter/SayHello",
  "/helloworld.Greeter/Login",
  "/helloworld.Greeter/Sign_up",
  "/helloworld.Greeter/User_inf",
  "/helloworld.Greeter/Search_username",
  "/helloworld.Greeter/Add_friend",
  "/helloworld.Greeter/Delete_friend",
  "/helloworld.Greeter/Create_share",
  "/helloworld.Greeter/Syn",
  "/helloworld.Greeter/Obtain_bills",
  "/helloworld.Greeter/Send_Img",
  "/helloworld.Greeter/Receive_Img",
  "/helloworld.Greeter/Reset_Status",
  "/helloworld.Greeter/Send_request",
  "/helloworld.Greeter/Obtain_request",
  "/helloworld.Greeter/Obtain_requestLog",
  "/helloworld.Greeter/Obtain_requestLogHistory",
  "/helloworld.Greeter/Request_response",
  "/helloworld.Greeter/MakePayment",
  "/helloworld.Greeter/IgnoreRequestLog",
  "/helloworld.Greeter/Create_requestLog",
};

std::unique_ptr< Greeter::Stub> Greeter::NewStub(const std::shared_ptr< ::grpc::ChannelInterface>& channel) {
  std::unique_ptr< Greeter::Stub> stub(new Greeter::Stub(channel));
  return stub;
}

Greeter::Stub::Stub(const std::shared_ptr< ::grpc::ChannelInterface>& channel)
  : ::grpc::InternalStub(channel), rpcmethod_SayHello_(Greeter_method_names[0], ::grpc::RpcMethod::NORMAL_RPC, channel->RegisterMethod(Greeter_method_names[0]))
  , rpcmethod_Login_(Greeter_method_names[1], ::grpc::RpcMethod::NORMAL_RPC, channel->RegisterMethod(Greeter_method_names[1]))
  , rpcmethod_Sign_up_(Greeter_method_names[2], ::grpc::RpcMethod::NORMAL_RPC, channel->RegisterMethod(Greeter_method_names[2]))
  , rpcmethod_User_inf_(Greeter_method_names[3], ::grpc::RpcMethod::NORMAL_RPC, channel->RegisterMethod(Greeter_method_names[3]))
  , rpcmethod_Search_username_(Greeter_method_names[4], ::grpc::RpcMethod::NORMAL_RPC, channel->RegisterMethod(Greeter_method_names[4]))
  , rpcmethod_Add_friend_(Greeter_method_names[5], ::grpc::RpcMethod::NORMAL_RPC, channel->RegisterMethod(Greeter_method_names[5]))
  , rpcmethod_Delete_friend_(Greeter_method_names[6], ::grpc::RpcMethod::NORMAL_RPC, channel->RegisterMethod(Greeter_method_names[6]))
  , rpcmethod_Create_share_(Greeter_method_names[7], ::grpc::RpcMethod::NORMAL_RPC, channel->RegisterMethod(Greeter_method_names[7]))
  , rpcmethod_Syn_(Greeter_method_names[8], ::grpc::RpcMethod::BIDI_STREAMING, channel->RegisterMethod(Greeter_method_names[8]))
  , rpcmethod_Obtain_bills_(Greeter_method_names[9], ::grpc::RpcMethod::SERVER_STREAMING, channel->RegisterMethod(Greeter_method_names[9]))
  , rpcmethod_Send_Img_(Greeter_method_names[10], ::grpc::RpcMethod::CLIENT_STREAMING, channel->RegisterMethod(Greeter_method_names[10]))
  , rpcmethod_Receive_Img_(Greeter_method_names[11], ::grpc::RpcMethod::SERVER_STREAMING, channel->RegisterMethod(Greeter_method_names[11]))
  , rpcmethod_Reset_Status_(Greeter_method_names[12], ::grpc::RpcMethod::NORMAL_RPC, channel->RegisterMethod(Greeter_method_names[12]))
  , rpcmethod_Send_request_(Greeter_method_names[13], ::grpc::RpcMethod::NORMAL_RPC, channel->RegisterMethod(Greeter_method_names[13]))
  , rpcmethod_Obtain_request_(Greeter_method_names[14], ::grpc::RpcMethod::SERVER_STREAMING, channel->RegisterMethod(Greeter_method_names[14]))
  , rpcmethod_Obtain_requestLog_(Greeter_method_names[15], ::grpc::RpcMethod::SERVER_STREAMING, channel->RegisterMethod(Greeter_method_names[15]))
  , rpcmethod_Obtain_requestLogHistory_(Greeter_method_names[16], ::grpc::RpcMethod::SERVER_STREAMING, channel->RegisterMethod(Greeter_method_names[16]))
  , rpcmethod_Request_response_(Greeter_method_names[17], ::grpc::RpcMethod::NORMAL_RPC, channel->RegisterMethod(Greeter_method_names[17]))
  , rpcmethod_MakePayment_(Greeter_method_names[18], ::grpc::RpcMethod::CLIENT_STREAMING, channel->RegisterMethod(Greeter_method_names[18]))
  , rpcmethod_IgnoreRequestLog_(Greeter_method_names[19], ::grpc::RpcMethod::NORMAL_RPC, channel->RegisterMethod(Greeter_method_names[19]))
  , rpcmethod_Create_requestLog_(Greeter_method_names[20], ::grpc::RpcMethod::NORMAL_RPC, channel->RegisterMethod(Greeter_method_names[20]))
  {}

::grpc::Status Greeter::Stub::SayHello(::grpc::ClientContext* context, const ::helloworld::HelloRequest& request, ::helloworld::HelloReply* response) {
  return ::grpc::BlockingUnaryCall(channel(), rpcmethod_SayHello_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::helloworld::HelloReply>* Greeter::Stub::AsyncSayHelloRaw(::grpc::ClientContext* context, const ::helloworld::HelloRequest& request, ::grpc::CompletionQueue* cq) {
  return new ::grpc::ClientAsyncResponseReader< ::helloworld::HelloReply>(channel(), cq, rpcmethod_SayHello_, context, request);
}

::grpc::Status Greeter::Stub::Login(::grpc::ClientContext* context, const ::helloworld::Login_m& request, ::helloworld::Inf* response) {
  return ::grpc::BlockingUnaryCall(channel(), rpcmethod_Login_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::helloworld::Inf>* Greeter::Stub::AsyncLoginRaw(::grpc::ClientContext* context, const ::helloworld::Login_m& request, ::grpc::CompletionQueue* cq) {
  return new ::grpc::ClientAsyncResponseReader< ::helloworld::Inf>(channel(), cq, rpcmethod_Login_, context, request);
}

::grpc::Status Greeter::Stub::Sign_up(::grpc::ClientContext* context, const ::helloworld::Sign_m& request, ::helloworld::Inf* response) {
  return ::grpc::BlockingUnaryCall(channel(), rpcmethod_Sign_up_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::helloworld::Inf>* Greeter::Stub::AsyncSign_upRaw(::grpc::ClientContext* context, const ::helloworld::Sign_m& request, ::grpc::CompletionQueue* cq) {
  return new ::grpc::ClientAsyncResponseReader< ::helloworld::Inf>(channel(), cq, rpcmethod_Sign_up_, context, request);
}

::grpc::Status Greeter::Stub::User_inf(::grpc::ClientContext* context, const ::helloworld::Inf& request, ::helloworld::User_detail* response) {
  return ::grpc::BlockingUnaryCall(channel(), rpcmethod_User_inf_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::helloworld::User_detail>* Greeter::Stub::AsyncUser_infRaw(::grpc::ClientContext* context, const ::helloworld::Inf& request, ::grpc::CompletionQueue* cq) {
  return new ::grpc::ClientAsyncResponseReader< ::helloworld::User_detail>(channel(), cq, rpcmethod_User_inf_, context, request);
}

::grpc::Status Greeter::Stub::Search_username(::grpc::ClientContext* context, const ::helloworld::Inf& request, ::helloworld::Repeated_string* response) {
  return ::grpc::BlockingUnaryCall(channel(), rpcmethod_Search_username_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::helloworld::Repeated_string>* Greeter::Stub::AsyncSearch_usernameRaw(::grpc::ClientContext* context, const ::helloworld::Inf& request, ::grpc::CompletionQueue* cq) {
  return new ::grpc::ClientAsyncResponseReader< ::helloworld::Repeated_string>(channel(), cq, rpcmethod_Search_username_, context, request);
}

::grpc::Status Greeter::Stub::Add_friend(::grpc::ClientContext* context, const ::helloworld::Repeated_string& request, ::helloworld::Inf* response) {
  return ::grpc::BlockingUnaryCall(channel(), rpcmethod_Add_friend_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::helloworld::Inf>* Greeter::Stub::AsyncAdd_friendRaw(::grpc::ClientContext* context, const ::helloworld::Repeated_string& request, ::grpc::CompletionQueue* cq) {
  return new ::grpc::ClientAsyncResponseReader< ::helloworld::Inf>(channel(), cq, rpcmethod_Add_friend_, context, request);
}

::grpc::Status Greeter::Stub::Delete_friend(::grpc::ClientContext* context, const ::helloworld::Repeated_string& request, ::helloworld::Inf* response) {
  return ::grpc::BlockingUnaryCall(channel(), rpcmethod_Delete_friend_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::helloworld::Inf>* Greeter::Stub::AsyncDelete_friendRaw(::grpc::ClientContext* context, const ::helloworld::Repeated_string& request, ::grpc::CompletionQueue* cq) {
  return new ::grpc::ClientAsyncResponseReader< ::helloworld::Inf>(channel(), cq, rpcmethod_Delete_friend_, context, request);
}

::grpc::Status Greeter::Stub::Create_share(::grpc::ClientContext* context, const ::helloworld::Share_inf& request, ::helloworld::Inf* response) {
  return ::grpc::BlockingUnaryCall(channel(), rpcmethod_Create_share_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::helloworld::Inf>* Greeter::Stub::AsyncCreate_shareRaw(::grpc::ClientContext* context, const ::helloworld::Share_inf& request, ::grpc::CompletionQueue* cq) {
  return new ::grpc::ClientAsyncResponseReader< ::helloworld::Inf>(channel(), cq, rpcmethod_Create_share_, context, request);
}

::grpc::ClientReaderWriter< ::helloworld::Inf, ::helloworld::Syn_data>* Greeter::Stub::SynRaw(::grpc::ClientContext* context) {
  return new ::grpc::ClientReaderWriter< ::helloworld::Inf, ::helloworld::Syn_data>(channel(), rpcmethod_Syn_, context);
}

::grpc::ClientAsyncReaderWriter< ::helloworld::Inf, ::helloworld::Syn_data>* Greeter::Stub::AsyncSynRaw(::grpc::ClientContext* context, ::grpc::CompletionQueue* cq, void* tag) {
  return new ::grpc::ClientAsyncReaderWriter< ::helloworld::Inf, ::helloworld::Syn_data>(channel(), cq, rpcmethod_Syn_, context, tag);
}

::grpc::ClientReader< ::helloworld::Share_inf>* Greeter::Stub::Obtain_billsRaw(::grpc::ClientContext* context, const ::helloworld::Bill_request& request) {
  return new ::grpc::ClientReader< ::helloworld::Share_inf>(channel(), rpcmethod_Obtain_bills_, context, request);
}

::grpc::ClientAsyncReader< ::helloworld::Share_inf>* Greeter::Stub::AsyncObtain_billsRaw(::grpc::ClientContext* context, const ::helloworld::Bill_request& request, ::grpc::CompletionQueue* cq, void* tag) {
  return new ::grpc::ClientAsyncReader< ::helloworld::Share_inf>(channel(), cq, rpcmethod_Obtain_bills_, context, request, tag);
}

::grpc::ClientWriter< ::helloworld::Image>* Greeter::Stub::Send_ImgRaw(::grpc::ClientContext* context, ::helloworld::Inf* response) {
  return new ::grpc::ClientWriter< ::helloworld::Image>(channel(), rpcmethod_Send_Img_, context, response);
}

::grpc::ClientAsyncWriter< ::helloworld::Image>* Greeter::Stub::AsyncSend_ImgRaw(::grpc::ClientContext* context, ::helloworld::Inf* response, ::grpc::CompletionQueue* cq, void* tag) {
  return new ::grpc::ClientAsyncWriter< ::helloworld::Image>(channel(), cq, rpcmethod_Send_Img_, context, response, tag);
}

::grpc::ClientReader< ::helloworld::Image>* Greeter::Stub::Receive_ImgRaw(::grpc::ClientContext* context, const ::helloworld::Repeated_string& request) {
  return new ::grpc::ClientReader< ::helloworld::Image>(channel(), rpcmethod_Receive_Img_, context, request);
}

::grpc::ClientAsyncReader< ::helloworld::Image>* Greeter::Stub::AsyncReceive_ImgRaw(::grpc::ClientContext* context, const ::helloworld::Repeated_string& request, ::grpc::CompletionQueue* cq, void* tag) {
  return new ::grpc::ClientAsyncReader< ::helloworld::Image>(channel(), cq, rpcmethod_Receive_Img_, context, request, tag);
}

::grpc::Status Greeter::Stub::Reset_Status(::grpc::ClientContext* context, const ::helloworld::Inf& request, ::helloworld::Inf* response) {
  return ::grpc::BlockingUnaryCall(channel(), rpcmethod_Reset_Status_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::helloworld::Inf>* Greeter::Stub::AsyncReset_StatusRaw(::grpc::ClientContext* context, const ::helloworld::Inf& request, ::grpc::CompletionQueue* cq) {
  return new ::grpc::ClientAsyncResponseReader< ::helloworld::Inf>(channel(), cq, rpcmethod_Reset_Status_, context, request);
}

::grpc::Status Greeter::Stub::Send_request(::grpc::ClientContext* context, const ::helloworld::Request& request, ::helloworld::Inf* response) {
  return ::grpc::BlockingUnaryCall(channel(), rpcmethod_Send_request_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::helloworld::Inf>* Greeter::Stub::AsyncSend_requestRaw(::grpc::ClientContext* context, const ::helloworld::Request& request, ::grpc::CompletionQueue* cq) {
  return new ::grpc::ClientAsyncResponseReader< ::helloworld::Inf>(channel(), cq, rpcmethod_Send_request_, context, request);
}

::grpc::ClientReader< ::helloworld::Request>* Greeter::Stub::Obtain_requestRaw(::grpc::ClientContext* context, const ::helloworld::Inf& request) {
  return new ::grpc::ClientReader< ::helloworld::Request>(channel(), rpcmethod_Obtain_request_, context, request);
}

::grpc::ClientAsyncReader< ::helloworld::Request>* Greeter::Stub::AsyncObtain_requestRaw(::grpc::ClientContext* context, const ::helloworld::Inf& request, ::grpc::CompletionQueue* cq, void* tag) {
  return new ::grpc::ClientAsyncReader< ::helloworld::Request>(channel(), cq, rpcmethod_Obtain_request_, context, request, tag);
}

::grpc::ClientReader< ::helloworld::Request>* Greeter::Stub::Obtain_requestLogRaw(::grpc::ClientContext* context, const ::helloworld::Inf& request) {
  return new ::grpc::ClientReader< ::helloworld::Request>(channel(), rpcmethod_Obtain_requestLog_, context, request);
}

::grpc::ClientAsyncReader< ::helloworld::Request>* Greeter::Stub::AsyncObtain_requestLogRaw(::grpc::ClientContext* context, const ::helloworld::Inf& request, ::grpc::CompletionQueue* cq, void* tag) {
  return new ::grpc::ClientAsyncReader< ::helloworld::Request>(channel(), cq, rpcmethod_Obtain_requestLog_, context, request, tag);
}

::grpc::ClientReader< ::helloworld::Request>* Greeter::Stub::Obtain_requestLogHistoryRaw(::grpc::ClientContext* context, const ::helloworld::Inf& request) {
  return new ::grpc::ClientReader< ::helloworld::Request>(channel(), rpcmethod_Obtain_requestLogHistory_, context, request);
}

::grpc::ClientAsyncReader< ::helloworld::Request>* Greeter::Stub::AsyncObtain_requestLogHistoryRaw(::grpc::ClientContext* context, const ::helloworld::Inf& request, ::grpc::CompletionQueue* cq, void* tag) {
  return new ::grpc::ClientAsyncReader< ::helloworld::Request>(channel(), cq, rpcmethod_Obtain_requestLogHistory_, context, request, tag);
}

::grpc::Status Greeter::Stub::Request_response(::grpc::ClientContext* context, const ::helloworld::Response& request, ::helloworld::Inf* response) {
  return ::grpc::BlockingUnaryCall(channel(), rpcmethod_Request_response_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::helloworld::Inf>* Greeter::Stub::AsyncRequest_responseRaw(::grpc::ClientContext* context, const ::helloworld::Response& request, ::grpc::CompletionQueue* cq) {
  return new ::grpc::ClientAsyncResponseReader< ::helloworld::Inf>(channel(), cq, rpcmethod_Request_response_, context, request);
}

::grpc::ClientWriter< ::helloworld::BillPayment>* Greeter::Stub::MakePaymentRaw(::grpc::ClientContext* context, ::helloworld::Inf* response) {
  return new ::grpc::ClientWriter< ::helloworld::BillPayment>(channel(), rpcmethod_MakePayment_, context, response);
}

::grpc::ClientAsyncWriter< ::helloworld::BillPayment>* Greeter::Stub::AsyncMakePaymentRaw(::grpc::ClientContext* context, ::helloworld::Inf* response, ::grpc::CompletionQueue* cq, void* tag) {
  return new ::grpc::ClientAsyncWriter< ::helloworld::BillPayment>(channel(), cq, rpcmethod_MakePayment_, context, response, tag);
}

::grpc::Status Greeter::Stub::IgnoreRequestLog(::grpc::ClientContext* context, const ::helloworld::IgnoreMessage& request, ::helloworld::Inf* response) {
  return ::grpc::BlockingUnaryCall(channel(), rpcmethod_IgnoreRequestLog_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::helloworld::Inf>* Greeter::Stub::AsyncIgnoreRequestLogRaw(::grpc::ClientContext* context, const ::helloworld::IgnoreMessage& request, ::grpc::CompletionQueue* cq) {
  return new ::grpc::ClientAsyncResponseReader< ::helloworld::Inf>(channel(), cq, rpcmethod_IgnoreRequestLog_, context, request);
}

::grpc::Status Greeter::Stub::Create_requestLog(::grpc::ClientContext* context, const ::helloworld::Request& request, ::helloworld::Inf* response) {
  return ::grpc::BlockingUnaryCall(channel(), rpcmethod_Create_requestLog_, context, request, response);
}

::grpc::ClientAsyncResponseReader< ::helloworld::Inf>* Greeter::Stub::AsyncCreate_requestLogRaw(::grpc::ClientContext* context, const ::helloworld::Request& request, ::grpc::CompletionQueue* cq) {
  return new ::grpc::ClientAsyncResponseReader< ::helloworld::Inf>(channel(), cq, rpcmethod_Create_requestLog_, context, request);
}

Greeter::AsyncService::AsyncService() : ::grpc::AsynchronousService(Greeter_method_names, 21) {}

Greeter::Service::~Service() {
  delete service_;
}

::grpc::Status Greeter::Service::SayHello(::grpc::ServerContext* context, const ::helloworld::HelloRequest* request, ::helloworld::HelloReply* response) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestSayHello(::grpc::ServerContext* context, ::helloworld::HelloRequest* request, ::grpc::ServerAsyncResponseWriter< ::helloworld::HelloReply>* response, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestAsyncUnary(0, context, request, response, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Login(::grpc::ServerContext* context, const ::helloworld::Login_m* request, ::helloworld::Inf* response) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestLogin(::grpc::ServerContext* context, ::helloworld::Login_m* request, ::grpc::ServerAsyncResponseWriter< ::helloworld::Inf>* response, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestAsyncUnary(1, context, request, response, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Sign_up(::grpc::ServerContext* context, const ::helloworld::Sign_m* request, ::helloworld::Inf* response) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestSign_up(::grpc::ServerContext* context, ::helloworld::Sign_m* request, ::grpc::ServerAsyncResponseWriter< ::helloworld::Inf>* response, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestAsyncUnary(2, context, request, response, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::User_inf(::grpc::ServerContext* context, const ::helloworld::Inf* request, ::helloworld::User_detail* response) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestUser_inf(::grpc::ServerContext* context, ::helloworld::Inf* request, ::grpc::ServerAsyncResponseWriter< ::helloworld::User_detail>* response, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestAsyncUnary(3, context, request, response, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Search_username(::grpc::ServerContext* context, const ::helloworld::Inf* request, ::helloworld::Repeated_string* response) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestSearch_username(::grpc::ServerContext* context, ::helloworld::Inf* request, ::grpc::ServerAsyncResponseWriter< ::helloworld::Repeated_string>* response, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestAsyncUnary(4, context, request, response, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Add_friend(::grpc::ServerContext* context, const ::helloworld::Repeated_string* request, ::helloworld::Inf* response) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestAdd_friend(::grpc::ServerContext* context, ::helloworld::Repeated_string* request, ::grpc::ServerAsyncResponseWriter< ::helloworld::Inf>* response, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestAsyncUnary(5, context, request, response, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Delete_friend(::grpc::ServerContext* context, const ::helloworld::Repeated_string* request, ::helloworld::Inf* response) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestDelete_friend(::grpc::ServerContext* context, ::helloworld::Repeated_string* request, ::grpc::ServerAsyncResponseWriter< ::helloworld::Inf>* response, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestAsyncUnary(6, context, request, response, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Create_share(::grpc::ServerContext* context, const ::helloworld::Share_inf* request, ::helloworld::Inf* response) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestCreate_share(::grpc::ServerContext* context, ::helloworld::Share_inf* request, ::grpc::ServerAsyncResponseWriter< ::helloworld::Inf>* response, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestAsyncUnary(7, context, request, response, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Syn(::grpc::ServerContext* context, ::grpc::ServerReaderWriter< ::helloworld::Syn_data, ::helloworld::Inf>* stream) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestSyn(::grpc::ServerContext* context, ::grpc::ServerAsyncReaderWriter< ::helloworld::Syn_data, ::helloworld::Inf>* stream, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestBidiStreaming(8, context, stream, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Obtain_bills(::grpc::ServerContext* context, const ::helloworld::Bill_request* request, ::grpc::ServerWriter< ::helloworld::Share_inf>* writer) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestObtain_bills(::grpc::ServerContext* context, ::helloworld::Bill_request* request, ::grpc::ServerAsyncWriter< ::helloworld::Share_inf>* writer, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestServerStreaming(9, context, request, writer, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Send_Img(::grpc::ServerContext* context, ::grpc::ServerReader< ::helloworld::Image>* reader, ::helloworld::Inf* response) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestSend_Img(::grpc::ServerContext* context, ::grpc::ServerAsyncReader< ::helloworld::Inf, ::helloworld::Image>* reader, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestClientStreaming(10, context, reader, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Receive_Img(::grpc::ServerContext* context, const ::helloworld::Repeated_string* request, ::grpc::ServerWriter< ::helloworld::Image>* writer) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestReceive_Img(::grpc::ServerContext* context, ::helloworld::Repeated_string* request, ::grpc::ServerAsyncWriter< ::helloworld::Image>* writer, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestServerStreaming(11, context, request, writer, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Reset_Status(::grpc::ServerContext* context, const ::helloworld::Inf* request, ::helloworld::Inf* response) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestReset_Status(::grpc::ServerContext* context, ::helloworld::Inf* request, ::grpc::ServerAsyncResponseWriter< ::helloworld::Inf>* response, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestAsyncUnary(12, context, request, response, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Send_request(::grpc::ServerContext* context, const ::helloworld::Request* request, ::helloworld::Inf* response) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestSend_request(::grpc::ServerContext* context, ::helloworld::Request* request, ::grpc::ServerAsyncResponseWriter< ::helloworld::Inf>* response, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestAsyncUnary(13, context, request, response, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Obtain_request(::grpc::ServerContext* context, const ::helloworld::Inf* request, ::grpc::ServerWriter< ::helloworld::Request>* writer) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestObtain_request(::grpc::ServerContext* context, ::helloworld::Inf* request, ::grpc::ServerAsyncWriter< ::helloworld::Request>* writer, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestServerStreaming(14, context, request, writer, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Obtain_requestLog(::grpc::ServerContext* context, const ::helloworld::Inf* request, ::grpc::ServerWriter< ::helloworld::Request>* writer) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestObtain_requestLog(::grpc::ServerContext* context, ::helloworld::Inf* request, ::grpc::ServerAsyncWriter< ::helloworld::Request>* writer, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestServerStreaming(15, context, request, writer, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Obtain_requestLogHistory(::grpc::ServerContext* context, const ::helloworld::Inf* request, ::grpc::ServerWriter< ::helloworld::Request>* writer) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestObtain_requestLogHistory(::grpc::ServerContext* context, ::helloworld::Inf* request, ::grpc::ServerAsyncWriter< ::helloworld::Request>* writer, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestServerStreaming(16, context, request, writer, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Request_response(::grpc::ServerContext* context, const ::helloworld::Response* request, ::helloworld::Inf* response) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestRequest_response(::grpc::ServerContext* context, ::helloworld::Response* request, ::grpc::ServerAsyncResponseWriter< ::helloworld::Inf>* response, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestAsyncUnary(17, context, request, response, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::MakePayment(::grpc::ServerContext* context, ::grpc::ServerReader< ::helloworld::BillPayment>* reader, ::helloworld::Inf* response) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestMakePayment(::grpc::ServerContext* context, ::grpc::ServerAsyncReader< ::helloworld::Inf, ::helloworld::BillPayment>* reader, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestClientStreaming(18, context, reader, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::IgnoreRequestLog(::grpc::ServerContext* context, const ::helloworld::IgnoreMessage* request, ::helloworld::Inf* response) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestIgnoreRequestLog(::grpc::ServerContext* context, ::helloworld::IgnoreMessage* request, ::grpc::ServerAsyncResponseWriter< ::helloworld::Inf>* response, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestAsyncUnary(19, context, request, response, new_call_cq, notification_cq, tag);
}

::grpc::Status Greeter::Service::Create_requestLog(::grpc::ServerContext* context, const ::helloworld::Request* request, ::helloworld::Inf* response) {
  return ::grpc::Status(::grpc::StatusCode::UNIMPLEMENTED);
}

void Greeter::AsyncService::RequestCreate_requestLog(::grpc::ServerContext* context, ::helloworld::Request* request, ::grpc::ServerAsyncResponseWriter< ::helloworld::Inf>* response, ::grpc::CompletionQueue* new_call_cq, ::grpc::ServerCompletionQueue* notification_cq, void *tag) {
  AsynchronousService::RequestAsyncUnary(20, context, request, response, new_call_cq, notification_cq, tag);
}

::grpc::RpcService* Greeter::Service::service() {
  if (service_ != nullptr) {
    return service_;
  }
  service_ = new ::grpc::RpcService();
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[0],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< Greeter::Service, ::helloworld::HelloRequest, ::helloworld::HelloReply>(
          std::mem_fn(&Greeter::Service::SayHello), this),
      new ::helloworld::HelloRequest, new ::helloworld::HelloReply));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[1],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< Greeter::Service, ::helloworld::Login_m, ::helloworld::Inf>(
          std::mem_fn(&Greeter::Service::Login), this),
      new ::helloworld::Login_m, new ::helloworld::Inf));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[2],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< Greeter::Service, ::helloworld::Sign_m, ::helloworld::Inf>(
          std::mem_fn(&Greeter::Service::Sign_up), this),
      new ::helloworld::Sign_m, new ::helloworld::Inf));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[3],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< Greeter::Service, ::helloworld::Inf, ::helloworld::User_detail>(
          std::mem_fn(&Greeter::Service::User_inf), this),
      new ::helloworld::Inf, new ::helloworld::User_detail));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[4],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< Greeter::Service, ::helloworld::Inf, ::helloworld::Repeated_string>(
          std::mem_fn(&Greeter::Service::Search_username), this),
      new ::helloworld::Inf, new ::helloworld::Repeated_string));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[5],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< Greeter::Service, ::helloworld::Repeated_string, ::helloworld::Inf>(
          std::mem_fn(&Greeter::Service::Add_friend), this),
      new ::helloworld::Repeated_string, new ::helloworld::Inf));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[6],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< Greeter::Service, ::helloworld::Repeated_string, ::helloworld::Inf>(
          std::mem_fn(&Greeter::Service::Delete_friend), this),
      new ::helloworld::Repeated_string, new ::helloworld::Inf));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[7],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< Greeter::Service, ::helloworld::Share_inf, ::helloworld::Inf>(
          std::mem_fn(&Greeter::Service::Create_share), this),
      new ::helloworld::Share_inf, new ::helloworld::Inf));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[8],
      ::grpc::RpcMethod::BIDI_STREAMING,
      new ::grpc::BidiStreamingHandler< Greeter::Service, ::helloworld::Inf, ::helloworld::Syn_data>(
          std::mem_fn(&Greeter::Service::Syn), this),
      new ::helloworld::Inf, new ::helloworld::Syn_data));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[9],
      ::grpc::RpcMethod::SERVER_STREAMING,
      new ::grpc::ServerStreamingHandler< Greeter::Service, ::helloworld::Bill_request, ::helloworld::Share_inf>(
          std::mem_fn(&Greeter::Service::Obtain_bills), this),
      new ::helloworld::Bill_request, new ::helloworld::Share_inf));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[10],
      ::grpc::RpcMethod::CLIENT_STREAMING,
      new ::grpc::ClientStreamingHandler< Greeter::Service, ::helloworld::Image, ::helloworld::Inf>(
          std::mem_fn(&Greeter::Service::Send_Img), this),
      new ::helloworld::Image, new ::helloworld::Inf));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[11],
      ::grpc::RpcMethod::SERVER_STREAMING,
      new ::grpc::ServerStreamingHandler< Greeter::Service, ::helloworld::Repeated_string, ::helloworld::Image>(
          std::mem_fn(&Greeter::Service::Receive_Img), this),
      new ::helloworld::Repeated_string, new ::helloworld::Image));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[12],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< Greeter::Service, ::helloworld::Inf, ::helloworld::Inf>(
          std::mem_fn(&Greeter::Service::Reset_Status), this),
      new ::helloworld::Inf, new ::helloworld::Inf));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[13],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< Greeter::Service, ::helloworld::Request, ::helloworld::Inf>(
          std::mem_fn(&Greeter::Service::Send_request), this),
      new ::helloworld::Request, new ::helloworld::Inf));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[14],
      ::grpc::RpcMethod::SERVER_STREAMING,
      new ::grpc::ServerStreamingHandler< Greeter::Service, ::helloworld::Inf, ::helloworld::Request>(
          std::mem_fn(&Greeter::Service::Obtain_request), this),
      new ::helloworld::Inf, new ::helloworld::Request));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[15],
      ::grpc::RpcMethod::SERVER_STREAMING,
      new ::grpc::ServerStreamingHandler< Greeter::Service, ::helloworld::Inf, ::helloworld::Request>(
          std::mem_fn(&Greeter::Service::Obtain_requestLog), this),
      new ::helloworld::Inf, new ::helloworld::Request));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[16],
      ::grpc::RpcMethod::SERVER_STREAMING,
      new ::grpc::ServerStreamingHandler< Greeter::Service, ::helloworld::Inf, ::helloworld::Request>(
          std::mem_fn(&Greeter::Service::Obtain_requestLogHistory), this),
      new ::helloworld::Inf, new ::helloworld::Request));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[17],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< Greeter::Service, ::helloworld::Response, ::helloworld::Inf>(
          std::mem_fn(&Greeter::Service::Request_response), this),
      new ::helloworld::Response, new ::helloworld::Inf));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[18],
      ::grpc::RpcMethod::CLIENT_STREAMING,
      new ::grpc::ClientStreamingHandler< Greeter::Service, ::helloworld::BillPayment, ::helloworld::Inf>(
          std::mem_fn(&Greeter::Service::MakePayment), this),
      new ::helloworld::BillPayment, new ::helloworld::Inf));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[19],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< Greeter::Service, ::helloworld::IgnoreMessage, ::helloworld::Inf>(
          std::mem_fn(&Greeter::Service::IgnoreRequestLog), this),
      new ::helloworld::IgnoreMessage, new ::helloworld::Inf));
  service_->AddMethod(new ::grpc::RpcServiceMethod(
      Greeter_method_names[20],
      ::grpc::RpcMethod::NORMAL_RPC,
      new ::grpc::RpcMethodHandler< Greeter::Service, ::helloworld::Request, ::helloworld::Inf>(
          std::mem_fn(&Greeter::Service::Create_requestLog), this),
      new ::helloworld::Request, new ::helloworld::Inf));
  return service_;
}


}  // namespace helloworld

