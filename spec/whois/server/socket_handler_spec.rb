require 'spec_helper'

describe Whois::Server::SocketHandler do

  describe "#call" do
    [ SystemCallError, SocketError ].each do |error|
      it "re-raises #{error} as Whois::ConnectionError" do
        subject.expects(:execute).raises(error)
        expect {
          subject.call("example.test", "whois.test", 43)
        }.to raise_error(Whois::ConnectionError, "#{error}: #{error.new.message}")
      end

      it "executes a socket connection for given args" do
        socket = stub()
        socket.expects(:write).with("example.test\r\n")
        socket.expects(:read)
        socket.expects(:close)

        TCPSocket.expects(:new).with("whois.test", 43).returns(socket)
        subject.call("example.test", "whois.test", 43)
      end
    end
  end

end
