
import Html exposing (..)
import Html.Attributes exposing (id, style, class, href, src, target)
import Html.Events exposing (onClick)
import String exposing (startsWith)
import Markdown

type alias Model = Int

-- UPDATE

type Action = Increment | Decrement

type Url = ExternalUrl String | AnchorLink String | LocalUrl String
toUrl : String -> Url
toUrl s = if | startsWith "http" s -> ExternalUrl s
             | startsWith "#" s -> AnchorLink s
             | otherwise -> LocalUrl s

fromUrl : Url -> String
fromUrl u = case u of
            LocalUrl s -> s
            ExternalUrl s -> s
            AnchorLink s -> s

type TimeSpan = TimeSpan String
type Company = Company String Url

home = div [ class "content"]
           [ menu
           -- , banner
           , title
           , introduction
           , projects
           , work
           , education
           , copyright
           ]

copyright : Html
copyright = article [class "small-print"] [text "This document is covered by copyright, modifications and derived works forbidden"]

menu : Html
menu = nav []
           [ul []
               [
                   menuLink (toUrl "#Projects") "Projects",
                   menuLink (toUrl "#WorkExperience") "Work Experience",
                   menuLink (toUrl "#Education") "Education",
                   menuLink (toUrl "http://github.com") "Github",
                   menuLink (toUrl "http://twitter.com") "Twitter"
               ] ]

introduction : Html
introduction = section [] [
    article [] [ Markdown.toHtml """
I am an experienced and highly capable Principal Software Engineer. I have a passion for
identifying ways to improve efficiency in software development, especially through
automation: if a computer can do it a computer should do it.

♥︎ Haskell, Javascript/NodeJS, Docker, the UNIX command line and ♡♥︎Vim
""" ] ]

menuLink : Url -> String -> Html
menuLink url content = case url of
                       ExternalUrl u -> li [] [ a [ href u
                                                  , target "_blank"
                                                  ]
                                                  [ text content ] ]
                       AnchorLink u -> li [] [ a [ href u ] [ text content ] ]
                       LocalUrl u -> li [] [ a [ href u ] [ text content ] ]

banner : Html
banner = header []
                [ div [] [ text "_" ]

                ]
title : Html
title = h1 [] [ em [] [ text "Lorcan"]
              , strong [] [ text "McDonald" ]
              ]

projects : Html
projects = section [ id "Projects" ]
                 [ h2 [] [ text "Projects" ]
                 , github "mars" (toUrl "https://github.com/lorcanmcdonald/mars")
                     (Just (LocalUrl "mars-static.png"))
                     (Markdown.toHtml """Mars is a REPL for exploring JSON
documents. It allows you to use familiar UNIX shell
commands to explore and update. I've found it useful to
get an overview of an unfamiliar API.

It's written in Haskell using [Parsec](https://hackage.haskell.org/package/parsec) to parse the
command line mini language.
""" )
                 , github "RegexCandidates"
                     (ExternalUrl "https://github.com/lorcanmcdonald/RegexCandidates")
                     Nothing
                     (Markdown.toHtml """A common problem I've noticed when reviewing regular expressions is
not that they don't match intended pattern, but rather that they will match
something unexpected. I wrote this web service to help identify these issues by
showing a list of random strings that would match a given regex.""" )
                 , github "ServerHere"
                     (ExternalUrl "https://github.com/lorcanmcdonald/ServerHere")
                     Nothing
                     (Markdown.toHtml """
`ServerHere` is a script to run a simple web server based in a particular
directory. It's convenient for working with small Javascript modules.
I've only recently published it on Github, but it actually predates
[`http-server`](https://github.com/indexzero/http-server).

No, I've never heard of [`python -m
SimpleHTTPServer`](https://docs.python.org/2/library/simplehttpserver.html),
why do you ask?""")
                 ]

break : Html
break = div [ style [("page-break-after", "always")]] []

work : Html
work = section []
               [ h2 [ id "WorkExperience" ] [ text "Work Experience" ]
               , serviceFrame
               , break
               , ibm
               , deecal
               , break
               , tradesports
               ]

education = section []
                    [ h2 [ id "Education"] [ text "Education" ]
                    , dcu
                    ]

dcu : Html
dcu = position "BSc. Computer Applications (Software Engineering)"
               (Company "DCU" (ExternalUrl "http://www.computing.dcu.ie/"))
               (TimeSpan "Sept 1999 → May 2003")
               (Markdown.toHtml """
Computer Applications is a four years honours degree covering practical aspects
of software engineering and theoretical topics in computer science.

I took a number of different modules Modules including:
- Software Engineering
- Languages and Computability
- Cryptography
- Graphics programming
- Systems Analysis

I also completed a six month work placement with Crannog Software, an company
selling network monitoring software.
""")

ibm : Html
ibm = position "Staff Software Engineer"
               (Company "IBM" (toUrl "http://ibm.com"))
               (TimeSpan "Sept 2008 → May 2012")
               (Markdown.toHtml """
As the technical lead on the XPages Mobile Controls project, I architected
and implemented the mobile web experience for Domino XPages (a web framework
for developing modern applications on Lotus Notes-Domino). The team size was
roughly 5-7 people, including developers, Quality Engineers and UX experts.

XPages Mobile controls allows you to create a single page web application for
mobile devices. It is built on top of the Dojo Mobile controls with significant
enhancements to work with Notes Domino and XPages. It uses Java Server Faces
(JSF) on the back end. The module is distributed as part of the [XPages
Extension
Library](http://extlib.openntf.org/main.nsf/project.xsp?r=project/XPages%20Extension%20Library/releases/07308990DF22F07686257E1300452C4E)
Open Source project.

While with IBM I had the opportunity to contribute a chapter to the [XPages
Extension Library](http://www.amazon.com/XPages-Extension-Library-Step-Step/dp/0132901811) book
and present to large audiences[¹](#ibm-footnote1) (including Lotusphere 2012). I also released a
small open source library, [xspUnit](http://extlib.openntf.org/main.nsf/project.xsp?r=project/XSPUnit/releases/3A1C5BE6C1A246CA862575A10034822C),
to allow unit testing of Server Side Javascript libraries in XPages.

<a name="ibm-footnote1"></a>¹ Topics included: Mobile Development, graphics programming using Quartz Mac OS X and the Vim text editor
""")

serviceFrame : Html
serviceFrame = position "Principal Engineer"
                        (Company "ServiceFrame" (toUrl "http://serviceframe.com"))
                        (TimeSpan "May 2012 → Present")
               (Markdown.toHtml """
ServiceFrame is a governance platform for outsourced relationships, typically
(but not limited to) the Telecoms Managed Services sector. It allows executive
users to monitor the Key Performance Indicators of a contractual relationship
and to collaborate and take action when required.

The team size has varied while I've been there but averaged about 4-7 people. I
was responsible for deciding priorities of incoming work, decomposing it into
tasks and assigning that work to team members. Once assigned I work with the
team members to work out estimates, track the progress of the items and
assist them when they have issues. This is in an agile framework where we are
continuously analysing the process to identify where we can make the process
more predictable and efficient.

It is comprised of a Single Page Javascript client application using an in house
CoffeeScript framework[¹](#sf-footnote1), a .Net 4.5 C# application serving a JSON
REST API and a Data Integration pipeline using a number of third party
ETL[²](#sf-footnote2) tools. These services were backed by both Relational (MySQL,
SQL Server and Postgres) and NoSQL (MongoDB) databases. A number of subsystems
are written in NodeJS (monitoring, build and data importing for example).

This is all hosted on 30-40 highly available instances on [Amazon Web
Services](https://aws.amazon.com).

I was tasked with working on all parts of this system, with particular
responsibility for the front end client application, the AWS infrastructure and
the build and deployment process.

Example achievements in these areas include decomposing UI elements into
composable components that can react to state changes efficiently and reliably.
A particularly important, and regularly overlooked part of this is providing a
standard way to serialising UI state to and from a URL.

In the infrastructure area I was nearly singlehandedly responsible for migrating
the existing infrastructure from an hosted co-location solution to AWS and
growing the infrastructure once we cut over to provide more reliable and safe
deployments. I used tools such as [Vagrant](http://vagrantup.com),
[Puppet](https://puppetlabs.com/puppet/what-is-puppet) and
[Docker](https://www.docker.com/whatisdocker) to produce an [Immutable
Infrastructure](http://martinfowler.com/bliki/ImmutableServer.html#footnote-coin)
style deployment.

<a name="sf-footnote1"></a>¹ There were a couple of reasons that we had to roll
our own framework here. At the time that we started the project, frameworks
like EmberJS, Knockout or React were in their infancy. Also, as we have users
based in a number of African countries, we had a number of design constraints
around performance. Both bandwidth and latency, and the low spec machines that
might be used by the users.

<a name="sf-footnote2"></a>² [Extract, Transform, Load](https://en.wikipedia.org/wiki/Extract,_transform,_load)
""")

deecal : Html
deecal = position "Senior Full Stack Developer"
                  (Company "Deecal International (later acquired by FirstData)" (toUrl "http://www.deecal.ie"))
                  (TimeSpan "Nov 2006 → Sept 2008")
               (Markdown.toHtml """"
At Deecal I worked on the main product d.cal. d.cal was an suite of
applications for managing corporate credit cards. It allowed you to monitor
real time transactions, handle expense claims and other common functions on
employee cards.

When I started the architecture was an early style of web application assembled
using multiple iframes. This sat in front of a J2EE application server (WebLogic
and later Tomcat) which then communicated with a Oracle 10g database.

The nature of the intercommunication between these individual iframe window was
causing a lot of trouble for the team and they required someone with expert
knowledge of front end development. I was taken on as a full stack developer
with special responsibility for improving knowledge an process in the front end
code.

This allowed me to introduce the team to the (at the time still reasonably new)
concepts of [AJAX](https://en.wikipedia.org/wiki/Ajax_(programming)),
[Unobtrusive Javascript](https://en.wikipedia.org/wiki/Unobtrusive_JavaScript)
and [jQuery](https://jquery.com).

Deecal International was acquired by FirstData in 2008.
""")

tradesports : Html
tradesports = position "Software Developer"
                  (Company "Trade Exchange Network"
                    (toUrl "https://en.wikipedia.org/wiki/Intrade"))
                  (TimeSpan "Feb 2004 → Nov 2006")
               (Markdown.toHtml """
Trade Exchange Network ran a number of prediction market products open to
public customers and in-house for a number of private clients. The consumer
sites included intrade.com, which catered primarily to financial and public
policy contracts and tradesports.com which modelled sports betting as a futures
market.

This was my first position after completing my studies and I was lucky to gain
a large amount of responsibility for large parts of the system quite early on
as I showed an aptitude for web development and UNIX systems administration.

I was personally responsible for the frontend code (i.e. Java Server Pages,
Javascript, HTML and CSS) for all the consumer properties. During my time there
I wrote an AJAX trading interface to show price updates in real time and allow
users to buy and sell contracts. Speed and correctness was particularly
important as this would be used to trade real money during fast moving sporting
and political events.

I was responsible for converting the sites from tables based designs to CSS. This
allowed us to swiftly produce high quality reskined sites for internal
corporate markets, typically within hours of a request coming in, this would
have taken weeks of work previously and was prone to mistakes.
""")

github : String -> Url -> Maybe Url -> Html -> Html
github = project "fa fa-github"

twitter : String -> Url -> Maybe Url -> Html -> Html
twitter = project "fa fa-twitter"

project : String -> String -> Url -> Maybe Url -> Html -> Html
project iconClass title url image content =
    let
        optionalImage = case image of
                             Just imageSrc -> [ img [ src (fromUrl imageSrc) ] [] ]
                             Nothing -> []
        heading = [ h3 []
                       [ span [ class iconClass ] []
                       , text " "
                       , a [ href (fromUrl url)] [ text title ] ]
                       ]
    in
        article [ ]
        <| List.foldr List.append [] [heading, optionalImage, [content] ]

position : String -> Company -> TimeSpan -> Html -> Html
position title (Company companyName companyUrl) (TimeSpan when) about =
    let
        urlString = fromUrl companyUrl
    in
       article []
       <| [ h3 [] [ text title ]
          , h4 [] [a [ href urlString ] [ text companyName ] ]
          , span [class "timespan"] [ text when ]
          ] `List.append` [ about ]

update : Action -> Model -> Model
update action model =
    case action of
        Increment -> model + 1
        Decrement -> model - 1

-- VIEW

view : Signal.Address Action -> Model -> Html
view address model = home

countStyle : Attribute
countStyle =
  style
    [ ("font-size", "20px")
    , ("font-family", "monospace")
    , ("display", "inline-block")
    , ("width", "50px")
    , ("text-align", "center")
    ]

-- SIGNALS

main : Signal Html
main =
  Signal.map (view actions.address) model

model : Signal Model
model =
  Signal.foldp update 0 actions.signal

actions : Signal.Mailbox Action
actions =
  Signal.mailbox Increment
