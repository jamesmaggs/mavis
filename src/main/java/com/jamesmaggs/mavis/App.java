package com.jamesmaggs.mavis;

import io.javalin.Javalin;

/**
 * Entry point for the Mavis web application.
 *
 * <p>This is the walking-skeleton seed: it serves a single greeting and echoes
 * posted input, so the full deploy pipeline can be proven before any real
 * conversational behaviour exists.
 */
public final class App {

    /** Port used when neither an argument nor the {@code PORT} env var is set. */
    static final int DEFAULT_PORT = 7070;

    private App() {
    }

    public static void main(String[] args) {
        start(resolvePort(args));
    }

    /**
     * Resolve the listen port: first CLI argument, else the {@code PORT}
     * environment variable (Railway's convention), else {@link #DEFAULT_PORT}.
     */
    static int resolvePort(String[] args) {
        if (args != null && args.length > 0 && !args[0].isBlank()) {
            return Integer.parseInt(args[0].trim());
        }
        String env = System.getenv("PORT");
        if (env != null && !env.isBlank()) {
            return Integer.parseInt(env.trim());
        }
        return DEFAULT_PORT;
    }

    /** Build, start and return the Javalin server on the given port. */
    static Javalin start(int port) {
        return Javalin.create()
                .get("/", ctx -> ctx.result("hello world"))
                .post("/echo", ctx -> ctx.result(ctx.body()))
                .start(port);
    }
}
