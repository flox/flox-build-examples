

jar:
	gradle shadowJar
	@echo "Build is at ./build/libs/quotes-app-jvm-all.jar"

clean:
	gradle clean
	gradle --stop || true
	rm -rf build .gradle
	@flox build clean

