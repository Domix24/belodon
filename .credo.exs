# This file contains the configuration for Credo and you are probably reading
# this after creating it with `mix credo.gen.config`.
#
# If you find anything wrong or unclear in this file, please report an
# issue on GitHub: https://github.com/rrrene/credo/issues
#
%{
  #
  # You can have as many configs as you like in the `configs:` field.
  configs: [
    %{
      #
      # Run any config using `mix credo -C <name>`. If no config name is given
      # "default" is used.
      #
      name: "default",
      #
      # These are the files included in the analysis:
      files: %{
        #
        # You can give explicit globs or simply directories.
        # In the latter case `**/*.{ex,exs}` will be used.
        #
        included: [
          "lib/",
          "src/",
          "test/",
          "web/",
          "apps/*/lib/",
          "apps/*/src/",
          "apps/*/test/",
          "apps/*/web/"
        ],
        excluded: [~r"/_build/", ~r"/deps/", ~r"/node_modules/"]
      },
      #
      # Load and configure plugins here:
      #
      plugins: [],
      #
      # If you create your own checks, you must specify the source files for
      # them here, so they can be loaded by Credo before running the analysis.
      #
      requires: [],
      #
      # If you want to enforce a style guide and need a more traditional linting
      # experience, you can change `strict` to `true` below:
      #
      strict: true,
      #
      # To modify the timeout for parsing files, change this value:
      #
      parse_timeout: 5000,
      #
      # If you want to use uncolored output by default, you can change `color`
      # to `false` below:
      #
      color: true,
      #
      # You can customize the parameters of any check by adding a second element
      # to the tuple.
      #
      # To disable a check put `false` as second element:
      #
      #     {Credo.Check.Design.DuplicatedCode, false}
      #
      checks: %{
        enabled: [
          #
          ## Consistency Checks
          #
          {Credo.Check.Consistency.ExceptionNames, [priority: :low]},
          {Credo.Check.Consistency.LineEndings, [priority: :low]},
          {Credo.Check.Consistency.ParameterPatternMatching, [priority: :low]},
          {Credo.Check.Consistency.SpaceAroundOperators, [priority: :low]},
          {Credo.Check.Consistency.SpaceInParentheses, [priority: :low]},
          {Credo.Check.Consistency.TabsOrSpaces, [priority: :low]},

          #
          ## Design Checks
          #
          # You can customize the priority of any check
          # Priority values are: `low, normal, high, higher`
          #
          {Credo.Check.Design.AliasUsage,
           [priority: :low, if_nested_deeper_than: 2, if_called_more_often_than: 0]},
          {Credo.Check.Design.TagFIXME, []},
          # You can also customize the exit_status of each check.
          # If you don't want TODO comments to cause `mix credo` to fail, just
          # set this value to 0 (zero).
          #
          {Credo.Check.Design.TagTODO, [exit_status: 2]},

          #
          ## Readability Checks
          #
          {Credo.Check.Readability.AliasOrder, [priority: :low]},
          {Credo.Check.Readability.FunctionNames, [priority: :low]},
          {Credo.Check.Readability.LargeNumbers, [priority: :low]},
          {Credo.Check.Readability.MaxLineLength, [priority: :low, max_length: 120]},
          {Credo.Check.Readability.ModuleAttributeNames, [priority: :low]},
          {Credo.Check.Readability.ModuleDoc, [priority: :low]},
          {Credo.Check.Readability.ModuleNames, [priority: :low]},
          {Credo.Check.Readability.ParenthesesInCondition, [priority: :low]},
          {Credo.Check.Readability.ParenthesesOnZeroArityDefs, [priority: :low]},
          {Credo.Check.Readability.PipeIntoAnonymousFunctions, [priority: :low]},
          {Credo.Check.Readability.PredicateFunctionNames, [priority: :low]},
          {Credo.Check.Readability.PreferImplicitTry, [priority: :low]},
          {Credo.Check.Readability.RedundantBlankLines, [priority: :low]},
          {Credo.Check.Readability.Semicolons, [priority: :low]},
          {Credo.Check.Readability.SpaceAfterCommas, [priority: :low]},
          {Credo.Check.Readability.StringSigils, [priority: :low]},
          {Credo.Check.Readability.TrailingBlankLine, [priority: :low]},
          {Credo.Check.Readability.TrailingWhiteSpace, [priority: :low]},
          {Credo.Check.Readability.UnnecessaryAliasExpansion, [priority: :low]},
          {Credo.Check.Readability.VariableNames, [priority: :low]},
          {Credo.Check.Readability.WithSingleClause, [priority: :low]},

          #
          ## Refactoring Opportunities
          #
          {Credo.Check.Refactor.Apply, [priority: :low]},
          {Credo.Check.Refactor.CondStatements, [priority: :low]},
          {Credo.Check.Refactor.CyclomaticComplexity, [priority: :low]},
          {Credo.Check.Refactor.FilterCount, [priority: :low]},
          {Credo.Check.Refactor.FilterFilter, [priority: :low]},
          {Credo.Check.Refactor.FunctionArity, [priority: :low]},
          {Credo.Check.Refactor.LongQuoteBlocks, [priority: :low]},
          {Credo.Check.Refactor.MapJoin, [priority: :low]},
          {Credo.Check.Refactor.MatchInCondition, [priority: :low]},
          {Credo.Check.Refactor.NegatedConditionsInUnless, [priority: :low]},
          {Credo.Check.Refactor.NegatedConditionsWithElse, [priority: :low]},
          {Credo.Check.Refactor.Nesting, [priority: :low]},
          {Credo.Check.Refactor.RedundantWithClauseResult, [priority: :low]},
          {Credo.Check.Refactor.RejectReject, [priority: :low]},
          {Credo.Check.Refactor.UnlessWithElse, [priority: :low]},
          {Credo.Check.Refactor.WithClauses, [priority: :low]},

          #
          ## Warnings
          #
          {Credo.Check.Warning.ApplicationConfigInModuleAttribute, [priority: :low]},
          {Credo.Check.Warning.BoolOperationOnSameValues, [priority: :low]},
          {Credo.Check.Warning.Dbg, [priority: :low]},
          {Credo.Check.Warning.ExpensiveEmptyEnumCheck, [priority: :low]},
          {Credo.Check.Warning.IExPry, [priority: :low]},
          {Credo.Check.Warning.IoInspect, [priority: :low]},
          {Credo.Check.Warning.MissedMetadataKeyInLoggerConfig, [priority: :low]},
          {Credo.Check.Warning.OperationOnSameValues, [priority: :low]},
          {Credo.Check.Warning.OperationWithConstantResult, [priority: :low]},
          {Credo.Check.Warning.RaiseInsideRescue, [priority: :low]},
          {Credo.Check.Warning.SpecWithStruct, [priority: :low]},
          {Credo.Check.Warning.UnsafeExec, [priority: :low]},
          {Credo.Check.Warning.UnusedEnumOperation, [priority: :low]},
          {Credo.Check.Warning.UnusedFileOperation, [priority: :low]},
          {Credo.Check.Warning.UnusedKeywordOperation, [priority: :low]},
          {Credo.Check.Warning.UnusedListOperation, [priority: :low]},
          {Credo.Check.Warning.UnusedPathOperation, [priority: :low]},
          {Credo.Check.Warning.UnusedRegexOperation, [priority: :low]},
          {Credo.Check.Warning.UnusedStringOperation, [priority: :low]},
          {Credo.Check.Warning.UnusedTupleOperation, [priority: :low]},
          {Credo.Check.Warning.WrongTestFileExtension, [priority: :low]},
#        ],
#        disabled: [
          #
          # Checks scheduled for next check update (opt-in for now)
          {Credo.Check.Refactor.UtcNowTruncate, []},

          #
          # Controversial and experimental checks (opt-in, just move the check to `:enabled`
          #   and be sure to use `mix credo --strict` to see low priority checks)
          #
          {Credo.Check.Consistency.MultiAliasImportRequireUse, []},
          {Credo.Check.Consistency.UnusedVariableNames, []},
          {Credo.Check.Design.DuplicatedCode, []},
          {Credo.Check.Design.SkipTestWithoutComment, []},
          {Credo.Check.Readability.AliasAs, []},
          {Credo.Check.Readability.BlockPipe, []},
          {Credo.Check.Readability.ImplTrue, []},
          {Credo.Check.Readability.MultiAlias, []},
          {Credo.Check.Readability.NestedFunctionCalls, []},
          {Credo.Check.Readability.OneArityFunctionInPipe, []},
          {Credo.Check.Readability.OnePipePerLine, []},
          {Credo.Check.Readability.SeparateAliasRequire, []},
          {Credo.Check.Readability.SingleFunctionToBlockPipe, []},
          {Credo.Check.Readability.SinglePipe, []},
          {Credo.Check.Readability.Specs, []},
          {Credo.Check.Readability.StrictModuleLayout, []},
          {Credo.Check.Readability.WithCustomTaggedTuple, []},
          {Credo.Check.Refactor.ABCSize, []},
          {Credo.Check.Refactor.AppendSingleItem, []},
          {Credo.Check.Refactor.DoubleBooleanNegation, []},
          {Credo.Check.Refactor.FilterReject, []},
          {Credo.Check.Refactor.IoPuts, []},
          {Credo.Check.Refactor.MapMap, []},
          {Credo.Check.Refactor.ModuleDependencies, []},
          {Credo.Check.Refactor.NegatedIsNil, []},
          {Credo.Check.Refactor.PassAsyncInTestCases, []},
          {Credo.Check.Refactor.PipeChainStart, []},
          {Credo.Check.Refactor.RejectFilter, []},
          {Credo.Check.Refactor.VariableRebinding, []},
#          {Credo.Check.Warning.LazyLogging, []},
          {Credo.Check.Warning.LeakyEnvironment, []},
          {Credo.Check.Warning.MapGetUnsafePass, []},
          {Credo.Check.Warning.MixEnv, []},
          {Credo.Check.Warning.UnsafeToAtom, []}

          # {Credo.Check.Refactor.MapInto, []},

          #
          # Custom checks can be created using `mix credo.gen.check`.
          #
        ]
      }
    }
  ]
}
