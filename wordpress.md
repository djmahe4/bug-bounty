# Bug Bounty Tip 🎯 - WordPress /wp-json/wp/v2/users/ Still Works in 2026 

WordPress user enumeration via REST API is old. It still works everywhere.<br>

curl target.com/wp-json/wp/v2/…<br>

Got: name, slug (= login username), user ID, profile URL<br>

Then the chain: Username known → /wp-login.php?action=lostpassword → host header injection in reset email → ATO
