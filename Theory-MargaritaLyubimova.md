# Part 2: Theory

## 1. Why did you choose the framework you used?

### I chose XCUItest for iOS and Espresso for Android because I haven't used those before and for me using that is a great opportunity to try something new and interesting. Moreover, the description of the coding challenge indicated that your company use mentioned frameworks for automation tests. So, I've tried to show that I'm able to figure out how to work with these technologies in a short time even if I didn't use that before.

## 2. What were the advantages and disadvantages of your choice?

### One of the biggest common advantages of the XCUITest and  Espresso is the same programming languages for testing and developing, so I think that communication between engineers in the development and in test and understanding each other's problems have a much higher level than in cases of using other test frameworks which have different programming languages. There are others of course, for example, native testing tools are up-to-date all the time and you don't need to wait half a year until Appium adds support for the latest iOS.

### Espresso: 

### At the time of choosing frameworks, we should completely understand what is needed and what we'd expect from automation tests. For example, if we'd like to check how applications work in collaboration with outer applications then Espresso not so useful. But in common cases which usually are the largest amount of tests when we're checking applications' inner functionality then Espresso is extremely nice - works fast, makes it possible to run tests directly from a chosen Activity and etc.

### XCUITest:

### Initially, I thought, XCUITest has one big disadvantage beside other smalls. Because XCUITest works in a separated sandbox and you don't have access to application sandbox, so you aren't able to read actual application parameters, unlike in Espresso. However, it helps us to write truly E2E tests aka black-box tests but a problem with a balance between stability, speed of passing and black-box tests is there anyway.  There are of course other things which aren't convenient, for example, having an accessibility id of ViewController would make life easier in case of checking that the next user flow or screen is being presented, but it isn't there in some reason.

## 3. What was the most complicated part?
### I was a bit difficult to synchronise data which should be presented and data which you're able to get for comparison because relying on a production server which has constantly changeable data will make our tests flaky, which is not a case and actually, in my opinion, it could be solved also on a test staging server. In the end, I didn't have a test staging server and had to manage it in another way, that's why it was a bit difficult, especially on iOS because of separated sandboxed of UI tests runner and application, which I mentioned above.

## 4. Which good coding practices did you follow when writing your tests?

## and

## 5. How do you make sure your code is maintainable by other team members?

### I'd like to combine answers to those questions in one. 

### I used the page object design pattern for tests to keep code maintainable. First of all, I tried to keep a single responsibility behaviour for each layer, eg: pages include information about elements on a certain screen and some action on those, tests include test scripts for checking expected and actual results and helpers/models include additional functions for getting data and messages and etc. I also tried to keep clear namings and follow OOP patterns like encapsulation, inheritance and polymorphism (there actually wasn't any case to use polymorphism, but anyway). Moreover,  I used a bit FP way, which I really like in Scala, which I think adds the clarity of code in cases of usage. Of course, some other good practices are there as well, eg: DRY, the repeated code collapsed into common functions, for example, fill a text field on iOS is actually is a function which makes tap on it and then enters a text. But from another hand, I've tried to follow YAGNI as well, so code which could be reused in the future but currently need to be used just once - isn't generalized into common functions. KISS principle also there, almost, I think (there is one case in each iOS and Android which are not the simplest, but they're related to data synchronisation which I mentioned above). SOLID principles also included, but it's a bit hard to follow all of it, Liskov substitution principle for example, or even combine YAGNI with the open-close principle, like, one final class is added to iOS tests, so it's closed for an extension from outside because of "you aren't gonna need it", but from another hand, it still could be extended by itself and in general I think that open-close principle is more architectural than just a recommendation as YAGNI is and most likely should be above of it.

### In conclusion, I'd like to say that all the points mentioned above help to keep clean and maintainable code. Onder than that, I'm completely open for new approaches and finding balance in a way which the whole team would like.
