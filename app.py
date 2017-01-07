import os
import sys
import json

import requests
from flask import Flask, request

# followings are debug variables
AI_ENABLE = False
WEBVIEW_ENABLE = True

app = Flask(__name__)


@app.route('/', methods=['GET'])
def verify():
    # when the endpoint is registered as a webhook, it must echo back
    # the 'hub.challenge' value it receives in the query arguments
    if request.args.get("hub.mode") == "subscribe" and request.args.get("hub.challenge"):
        if not request.args.get("hub.verify_token") == os.environ["VERIFY_TOKEN"]:
            return "Verification token mismatch", 403
        return request.args["hub.challenge"], 200
    return "Hello world", 200


@app.route('/', methods=['POST'])
def webhook():
    # endpoint for processing incoming messaging events
    data = request.get_json()
    log(data)  # you may not want to log every incoming message in production, but it's good for testing
    if data["object"] == "page":
        for entry in data["entry"]:
            for messaging_event in entry["messaging"]:
                if messaging_event.get("message"):  # someone sent us a message
                    sender_id = messaging_event["sender"]["id"]        # the facebook ID of the person sending you the message
                    recipient_id = messaging_event["recipient"]["id"]  # the recipient's ID, which should be your page's facebook ID
                    message_text = messaging_event["message"]["text"]  # the message's text
                    if message_text == "show me pics":
                        image_url = 'http://cdn.playbuzz.com/cdn/f66c0537-4323-4544-8c4b-43b1f9efe9b2/894a1671-e7fb-4e37-a750-0cd6834c6dee.jpg'
                        send_images(sender_id, image_url)
                    elif message_text == "show me buttons":
                        send_image_buttons(sender_id, message_text)
                    else:
                        reply_text = "I am chatbot, I received "+message_text
                        send_message(sender_id, reply_text)
                    #send_message(sender_id, "got it, thanks!")
                if messaging_event.get("delivery"):  # delivery confirmation
                    pass
                if messaging_event.get("optin"):  # optin confirmation
                    pass
                if messaging_event.get("postback"):  # user clicked/tapped "postback" button in earlier message
                    pass
    return "ok", 200

def send_data(params, headers, data):
    r = requests.post("https://graph.facebook.com/v2.6/me/messages", params=params, headers=headers, data=data)
    if r.status_code != 200:
        log(r.status_code)
        log(r.text)

def send_image_buttons(recipient_id, message_text):
    params = {
        "access_token": os.environ["PAGE_ACCESS_TOKEN"]
    }
    headers = {
        "Content-Type": "application/json"
    }
    data = json.dumps({
        "recipient": {
            "id": recipient_id
        },
        "message": {
            "attachment": {
                "type": "template",
                "payload": {
                    "template_type": "generic",
                    "elements": [{
                        "title": "title1",
                        "subtitle": "subtitle1",
                        "image_url": 'http://cdn.playbuzz.com/cdn/f66c0537-4323-4544-8c4b-43b1f9efe9b2/894a1671-e7fb-4e37-a750-0cd6834c6dee.jpg',
                        "buttons": [{
                            "type": "web_url",
                            "url": "https://www.google.com",
                            "title": "Open Web URL"
                            }, 
                            {
                            "type": "postback",
                            "title": "Call Postback",
                            "payload": "Payload for first bubble",
                            }],
                    }, 
                    {
                        "title": "title2",
                        "subtitle": "subtitle2",
                        "image_url": 'http://cdn.playbuzz.com/cdn/f66c0537-4323-4544-8c4b-43b1f9efe9b2/894a1671-e7fb-4e37-a750-0cd6834c6dee.jpg',
                        "buttons": [{
                            "type": "web_url",
                            "url": "https://www.google.com",
                            "title": "Open Web URL"
                            }, 
                            {
                            "type": "postback",
                            "title": "Call Postback",
                            "payload": "Payload for second bubble",
                            }]
                    }]
                }
            }
        }
    })
    send_data(params, headers, data)

def send_images(recipient_id, image_url):
    params = {
        "access_token": os.environ["PAGE_ACCESS_TOKEN"]
    }
    headers = {
        "Content-Type": "application/json"
    }
    data = json.dumps({
        "recipient": {
            "id": recipient_id
        },
        "message": {
            'attachment': {
                'type': "image",
                'payload': {
                    'url': image_url
                }
            }
        }
    })
    send_data(params, headers, data)
   
def send_message(recipient_id, message_text):
    params = {
        "access_token": os.environ["PAGE_ACCESS_TOKEN"]
    }
    headers = {
        "Content-Type": "application/json"
    }
    data = json.dumps({
        "recipient": {
            "id": recipient_id
        },
        "message": {
            "text": message_text
        }
    })
    send_data(params, headers, data)
   

def log(message):  # simple wrapper for logging to stdout on heroku
    print str(message)
    sys.stdout.flush()


if __name__ == '__main__':
    app.run(debug=True)
