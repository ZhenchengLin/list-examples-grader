#set -e

CPATH='.:lib/hamcrest-core-1.3.jar:lib/junit-4.13.2.jar'

rm ./*.class
rm -rf student-submission
rm -rf grading-area

mkdir grading-area

git clone $1 student-submission
echo 'Finished cloning'


# Draw a picture/take notes on the directory structure that's set up after
# getting to this point

# Then, add here code to compile and run, and do any post-processing of the
# tests

# -z if the string is empty Check if $1 is empty
if [ -z "$1" ]; then 
    echo "empty input, plese privided a url"
    exit 1
fi

git clone "$1"  grading-area 

if [ $? != 0 ]; then
    echo "Failed to clone"
    exit 1
fi

if [ -f ListExamples.java ]; then
    echo "Missing file"
    exit 1
fi

cp student-submission/* grading-area/ 
echo "Passed Copy" >> R.txt


javac grading-area/*.java

if [ $? != 0 ]; then
    echo "Compiling Error when calling clone java code"
    exit 1
fi
echo "Passed clone" >> R.txt


cd ./grading-area

javac ListExamples.java


cd .. 


cd ./student-submission

javac ListExamples.java

if [ $? != 0 ]; then
    echo "Compiling Error when calling ListExamples java in grading-area or student-submission code"
    exit 1
fi
echo "Passed ListExamples in Grading-area and student-submission" >> R.txt


cd ..

cp student-submission/*class ./

javac -cp $CPATH *.java 

if [ $? != 0 ]; then
    echo "Compiling Error at list-examples-grader"
    exit 1
fi
echo "Passed Compiling list-examples-grader" >> R.txt


java -cp $CPATH org.junit.runner.JUnitCore TestListExamples >>return.txt

if [ $? != 0 ]; then
    echo "Test failures!!" 
    exit 1
fi

echo "Passed Test class" >> R.txt

cat R.txt


rm ./*.class
rm ./*.txt
rm -rf student-submission
rm -rf grading-area
