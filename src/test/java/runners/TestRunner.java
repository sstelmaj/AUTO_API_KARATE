package runners;

import com.intuit.karate.junit5.Karate;

class TestRunner {

    @Karate.Test
    Karate testAll() {
        return Karate.run("classpath:features").relativeTo(getClass());
    }

    @Karate.Test
    Karate testGet() {
        return Karate.run("classpath:features/get").relativeTo(getClass());
    }

    @Karate.Test
    Karate testPost() {
        return Karate.run("classpath:features/post").relativeTo(getClass());
    }

    @Karate.Test
    Karate testPut() {
        return Karate.run("classpath:features/put").relativeTo(getClass());
    }

    @Karate.Test
    Karate testDelete() {
        return Karate.run("classpath:features/delete").relativeTo(getClass());
    }
}
