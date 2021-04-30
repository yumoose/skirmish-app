echo "Checking environment dependencies 📦"
which npm || ("NPM not installed. Visit https://www.npmjs.com/get-npm to get started" && exit)
which flutter || (echo "Flutter not installed. Visit https://flutter.dev/docs/get-started/install to get started" && exit)

echo
echo "Setting up environment dependencies 💾"
which supabase || npm i -g supabase

echo
echo "Setting up app dependencies 🎱"
flutter pub get
cd functions && npm install && cd ..
