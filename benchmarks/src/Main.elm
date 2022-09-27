module Main exposing (main)

import Benchmark.Runner
import Suite exposing (suite)


main : Benchmark.Runner.BenchmarkProgram
main =
    Benchmark.Runner.program suite
