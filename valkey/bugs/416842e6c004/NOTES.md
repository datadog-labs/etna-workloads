repro.sh: a raw-socket client sends CLIENT REPLY OFF, then SUBSCRIBE ch; another client PUBLISHes.
Clean: the subscribe confirmation and the pubsub message are still delivered (push messages bypass reply-off).
Buggy: nothing is delivered to the subscriber, because the CLIENT_PUSHING exemption is gone.
