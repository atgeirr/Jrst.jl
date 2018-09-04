g = CartesianGrid((2, 3, 4), (1.0, 1.0, 1.0))

@test numCells(g) == 24
@test numFaces(g) == 98
@test numDirFaces(g, 1) == 36
@test numDirFaces(g, 2) == 32
@test numDirFaces(g, 3) == 30

@test ijkToLin(g, (1,1,1)) == 1
@test ijkToLin(g, (2,1,1)) == 2
@test ijkToLin(g, (1,2,1)) == 3
@test ijkToLin(g, (1,1,2)) == 7
@test ijkToLin(g, (2,3,4)) == 24

for i = 1:numCells(g)
    @test ijkToLin(g, linToIJK(g, i)) == i
end

@test entityIJKToFace(g, (1, 2, 2)) == 1
@test faceToEntityIJK(g, 1) == (1, 2, 2)

for f = 1:numFaces(g)
    @test entityIJKToFace(g, faceToEntityIJK(g, f)) == f
end



@test linToIJK(g, 9) == (1, 2, 2)
@test cellFaces(g, 9) == [13, 14, 47, 49, 77, 83]
@test cellFaces(g, (1, 1, 1)) == [1, 2, 37, 39, 69, 75]
@test cellFaces(g, (2, 3, 4)) == [35, 36, 66, 68, 92, 98]

@test faceCells(g, 2) == (1, 2)
@test faceCells(g, 1) == (0, 1)
@test faceCells(g, 98) == (24, 0)
@test faceCells(g, 36) == (24, 0)
@test faceCells(g, 37) == (0, 1)
@test faceCells(g, 38) == (0, 2)
@test faceCells(g, 39) == (1, 3)
