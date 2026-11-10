"$1" --permission -e 'try{(new (require("inspector")).Session()).connect();console.log("connected")}catch(e){console.log(e.code)}' 2>&1
echo "exit=$?"
