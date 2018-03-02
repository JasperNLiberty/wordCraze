from flask import Flask, jsonify, request
import glob
import os
import numpy as np
from pymongo import MongoClient

client = MongoClient()
db = client.test

app = Flask(__name__)

hostIP = '0.0.0.0'
hostPort = 7000

@app.route("/retrieveSen")
def sendSenAsList():
	word = request.args.get("word")
	for doc in db.wordsTest3.find({"wordId":word}):
		senCol = doc["exampleSens"]
	return jsonify({"word":word, "senCol" : senCol})

@app.route("/retrieveMp3")
def sendMp3Link():
	word = request.args.get("word")
	mp3fileBasename = word + '.mp3'
	return jsonify({"word":word,"mp3link" : 'http://'+hostIP+':'+ str(hostPort) +'/static/'+ mp3fileBasename})

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
