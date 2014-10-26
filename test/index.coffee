platformOverrides = require '../'
chai = require 'chai'
expect = chai.expect
fs = require 'fs'
path = require 'path'

getFixture = (pathSegment) ->
    fs.readFileSync(path.join './test/fixtures/', pathSegment).toString()
getExpected = (pathSegment, basename) ->
    fs.readFileSync(path.join './test/expected/', pathSegment, basename + '.json').toString()


describe 'platform-overrides', ->
    it 'should apply overrides correctly for each platform', ->
        for platform in ['osx', 'win', 'linux32', 'linux64']
            result = platformOverrides
                options: getFixture 'all/package.json'
                platform: platform

            expect(result).to.be.a 'string'
            expect(JSON.parse result).to.deep.equal JSON.parse getExpected 'all', platform

    it 'should support passing an object and then return an object', ->
        for platform in ['osx', 'win', 'linux32', 'linux64']
            result = platformOverrides
                options: JSON.parse getFixture 'all/package.json'
                platform: platform

            expect(result).to.be.an 'object'
            expect(result).to.deep.equal JSON.parse getExpected 'all', platform

    it 'should support not passing a platform', ->
        platformOverrides
            options: JSON.parse getFixture 'all/package.json'

    it 'should apply overrides correctly for appropriate platforms and strip platformOverrides regardless', ->
        for platform in ['osx', 'win', 'linux32', 'linux64']
            result = platformOverrides
                options: getFixture 'oneOveriddenRestNot/package.json'
                platform: platform

            expect(JSON.parse result).to.deep.equal JSON.parse getExpected(
                'oneOveriddenRestNot',
                if platform is 'osx' then platform else 'rest'
            )

    it 'should leave file as is if platformOverrides does not exist', ->
        for platform in ['osx', 'win', 'linux32', 'linux64']
            contents = getFixture 'none/package.json'

            result = platformOverrides
                options: contents
                platform: platform

            expect(result).to.equal contents

    it 'should return an error if invalid JSON is passed', ->
        result = platformOverrides
            options: '{a:0'

        expect(result instanceof Error).to.equal true