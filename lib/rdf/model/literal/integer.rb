module RDF; class Literal
  ##
  # An integer literal.
  #
  # @example Arithmetic with integer literals
  #   RDF::Literal(40) + 2                    #=> RDF::Literal(42)
  #   RDF::Literal(45) - 3                    #=> RDF::Literal(42)
  #   RDF::Literal(6) * 7                     #=> RDF::Literal(42)
  #   RDF::Literal(84) / 2                    #=> RDF::Literal(42)
  #
  # @see   http://www.w3.org/TR/xmlschema-2/#integer
  # @since 0.2.1
  class Integer < Decimal
    DATATYPE = XSD.integer
    GRAMMAR  = /^[\+\-]?\d+$/.freeze

    ##
    # @param  [Integer, #to_i] value
    # @option options [String] :lexical (nil)
    def initialize(value, options = {})
      @datatype = RDF::URI(options[:datatype] || DATATYPE)
      @string   = options[:lexical] if options.has_key?(:lexical)
      @string   = value if !defined?(@string) && value.is_a?(String)
      @object   = case
        when value.is_a?(::String)    then Integer(value) rescue nil
        when value.is_a?(::Integer)   then value
        when value.respond_to?(:to_i) then value.to_i
        else Integer(value.to_s) rescue nil
      end
    end

    ##
    # Converts the literal into its canonical lexical representation.
    #
    # @return [Literal]
    # @see    http://www.w3.org/TR/xmlschema-2/#integer
    def canonicalize
      @string = @object.to_s if @object
      self
    end

    ##
    # Returns the successor value of `self`.
    #
    # @return [RDF::Literal]
    # @since  0.2.3
    def pred
      RDF::Literal(to_i.pred)
    end

    ##
    # Returns the predecessor value of `self`.
    #
    # @return [RDF::Literal]
    # @since  0.2.3
    def succ
      RDF::Literal(to_i.succ)
    end
    alias_method :next, :succ

    ##
    # Returns `true` if the value is even.
    #
    # @return [Boolean]
    # @since  0.2.3
    def even?
      to_i.even?
    end

    ##
    # Returns `true` if the value is odd.
    #
    # @return [Boolean]
    # @since  0.2.3
    def odd?
      to_i.odd?
    end

    ##
    # Returns the absolute value of `self`.
    #
    # @return [RDF::Literal]
    # @since  0.2.3
    def abs
      (n = to_i) && n > 0 ? self : RDF::Literal(n.abs)
    end

    ##
    # Returns `true` if the value is zero.
    #
    # @return [Boolean]
    # @since  0.2.3
    def zero?
      to_i.zero?
    end

    ##
    # Returns `self` if the value is not zero, `nil` otherwise.
    #
    # @return [Boolean]
    # @since  0.2.3
    def nonzero?
      to_i.nonzero? ? self : nil
    end

    ##
    # Returns `self`.
    #
    # @return [RDF::Literal]
    # @since  0.2.3
    def +@
      self # unary plus
    end

    ##
    # Returns `self` negated.
    #
    # @return [RDF::Literal]
    # @since  0.2.3
    def -@
      RDF::Literal(-to_i) # unary minus
    end

    ##
    # Returns the sum of `self` plus `other`.
    #
    # @param  [#to_i] other
    # @return [RDF::Literal]
    # @since  0.2.3
    def +(other)
      RDF::Literal(to_i + other.to_i)
    end

    ##
    # Returns the difference of `self` minus `other`.
    #
    # @param  [#to_i] other
    # @return [RDF::Literal]
    # @since  0.2.3
    def -(other)
      RDF::Literal(to_i - other.to_i)
    end

    ##
    # Returns the product of `self` times `other`.
    #
    # @param  [#to_i] other
    # @return [RDF::Literal]
    # @since  0.2.3
    def *(other)
      RDF::Literal(to_i * other.to_i)
    end

    ##
    # Returns the quotient of `self` divided by `other`.
    #
    # @param  [#to_i] other
    # @return [RDF::Literal]
    # @raise  [ZeroDivisionError] if divided by zero
    # @since  0.2.3
    def /(other)
      RDF::Literal(to_i / other.to_i)
    end

    ##
    # Returns the value as a string.
    #
    # @return [String]
    def to_s
      @string || @object.to_s
    end

    ##
    # Returns the value as an integer.
    #
    # @return [Integer]
    def to_i
      @object.to_i
    end
    alias_method :to_int, :to_i
    alias_method :ord,    :to_i

    ##
    # Returns the value as a floating point number.
    #
    # @return [Float]
    def to_f
      @object.to_f
    end

    ##
    # Returns the value as a decimal number.
    #
    # @return [BigDecimal]
    def to_d
      @object.respond_to?(:to_d) ? @object.to_d : BigDecimal(@object.to_s)
    end

    ##
    # Returns the value as a rational number.
    #
    # @return [Rational]
    def to_r
      @object.to_r
    end
  end # class Integer
end; end # class RDF::Literal