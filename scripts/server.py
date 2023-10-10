# Python 3 server example
from http.server import BaseHTTPRequestHandler, HTTPServer
import subprocess

hostName = "localhost"
serverPort = 6969

class MyServer(BaseHTTPRequestHandler):
    def run(self, script):
        completed = subprocess.run(['sh', script], text=True, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)
        return (200 if completed.returncode == 0 else 500, str(completed.stdout))

    def do_GET(self):
        if self.path == "/wake_pc":
            code, message = self.run('./wake_pc.sh')
        elif self.path == "/sleep_pc":
            code, message = self.run('./sleep_pc.sh')
        elif self.path == "/start_jupyter":
            code, message = self.run('./start_jupyter.sh')
        elif self.path == "/stop_jupyter":
            code, message = self.run('./stop_jupyter.sh')
        else:
            self.send_response(404)
            return
        
        self.send_response(code)
        self.send_header('Content-Type', 'text/plain')

        content_length = len(message.encode('utf-8'))
        self.send_header('Content-Length', content_length)
        self.end_headers()

        self.wfile.write(message.encode('utf-8'))

if __name__ == "__main__":        
    webServer = HTTPServer((hostName, serverPort), MyServer)
    print("Server started http://%s:%s" % (hostName, serverPort))
    webServer.serve_forever()
