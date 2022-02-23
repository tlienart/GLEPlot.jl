struct NotImplementedError <: Exception
    msg::String
    NotImplementedError(s) = new(
        "[$s] hasn't been implemented."
    )
end

struct UnknownOptionError <: Exception
    msg::String
    UnknownOptionError(s, o) = new(
        "[$s] is not recognised as a valid option name for $(typeof(o))."
    )
end

struct OptionValueError <: Exception
    msg::String
    OptionValueError(s, v) = new(
        "[$s] value given ($v) did not meet the expected format."
    )
end
