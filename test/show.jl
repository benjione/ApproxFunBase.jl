@testset "show" begin
	io = IOBuffer()
	@testset "Domain" begin
		@testset "Segment" begin
			s = Segment(0, 1)
			@test contains(repr(s), repr(leftendpoint(s)))
			@test contains(repr(s), repr(rightendpoint(s)))
		end
	end
	@testset "Space" begin
		@testset "ConstantSpace" begin
			@test contains(repr(ConstantSpace()), "ConstantSpace")
			c = ConstantSpace(0..1)
			@test contains(repr(c), "ConstantSpace")
			@test contains(repr(c), repr(domain(c)))
		end
		@testset "TensorSpace" begin
			S1 = PointSpace(1:3)
			S = S1 ⊗ S1
			v = strip.(split(repr(S), '⊗'))
			@test length(v) == 2
			@test all(==(repr(S1)), v)
		end
		@testset "SumSpace" begin
			S1 = PointSpace(1:3)
			S = S1 ⊕ S1
			v = strip.(split(repr(S), '⊕'))
			@test length(v) == 2
			@test all(==(repr(S1)), v)
		end
		@testset "PiecewiseSpace" begin
			p = PointSpace(1:4)
			ps = PiecewiseSpace(p)
			rpr = repr(ps)
			@test contains(rpr, "PiecewiseSpace")
			@test contains(rpr, repr(p))
		end
	end
	@testset "Fun" begin
		f = Fun(PointSpace(1:3), [1,2,3])
		s = repr(f)
		@test startswith(s, "Fun")
		@test contains(s, repr(space(f)))
		@test contains(s, repr(coefficients(f)))

		f = Fun(ConstantSpace(0..1), [2])
		@test contains(repr(f), repr(f(0)))
		@test contains(repr(f), repr(domain(f)))

		f = Fun(ConstantSpace(), [2])
		@test contains(repr(f), repr(f(0)))

		f = Fun(ApproxFunBase.ArraySpace([ConstantSpace(0..1)]), [3])
		@test contains(repr(f), repr(f(0)))
	end
	@testset "Operator" begin
		@testset "QuotientSpace" begin
			Q = QuotientSpace(Dirichlet(ConstantSpace(0..1)))
			@test startswith(repr(Q), "ConstantSpace(0..1) /")
			show(io, MIME"text/plain"(), Q)
			s = String(take!(io))
			@test startswith(s, "ConstantSpace(0..1) /")
		end
		@testset "ConstantOperator" begin
			A = I : PointSpace(1:4)
			s = summary(A)
			@test startswith(s, "ConstantOperator")
		end
	end
end
