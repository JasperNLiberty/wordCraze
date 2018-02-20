from flask import Flask, jsonify
import glob
import os
import numpy as np

app = Flask(__name__)

hostIP = '0.0.0.0'
hostPort = 7000

@app.route("/serveRandomWord")
def sendList():
    # return "123"
    files = glob.glob(os.getcwd()+'/static/*.mp3')
    nFiles = len(files)
    rNum = np.random.randint(nFiles)
    mp3file = files[rNum]
    mp3fileBasename = os.path.basename(mp3file)
    return jsonify({"word":mp3fileBasename[0:-4],"mp3link" : 'http://'+hostIP+':'+ str(hostPort) +'/static/'+ mp3fileBasename})
    # return 'http://'+hostIP+':'+ str(hostPort) +'/static/'+ mp3fileBasename

if __name__ == "__main__":
    app.run(host=hostIP, debug=True, port=hostPort)
