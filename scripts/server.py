# Python 3 server example
from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess

hostName = "localhost"
serverPort = 6969

class MyServer(BaseHTTPRequestHandler):
    def wake_pc(self):
        completed = subprocess.run(['sh', './wake_pc.sh'])
        return 200 if completed.returncode == 0 else 500

    def sleep_pc(self):
        completed = subprocess.run(['sh', './sleep_pc.sh'])
        return 200 if completed.returncode == 0 else 500

    def start_jupyter(self):
        completed = subprocess.run(['sh', './start_jupyter.sh'])
        return 200 if completed.returncode == 0 else 500

    def stop_jupyter(self):
        completed = subprocess.run(['sh', './stop_jupyter.sh'])
        return 200 if completed.returncode == 0 else 500

    def do_GET(self):
        if self.path == "/wake_pc":
            self.send_response(self.wake_pc())
        elif self.path == "/sleep_pc":
            self.send_response(self.sleep_pc())
        elif self.path == "/start_jupyter":
            self.send_response(self.start_jupyter())
        elif self.path == "/stop_jupyter":
            self.send_response(self.stop_jupyter())
        else:
            self.send_response(404)
            return

if __name__ == "__main__":        
    webServer = HTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))

    try:
        webServer.serve_forever()
    except KeyboardInterrupt:
        pass

    webServer.server_close()
    print("Server stopped.")
