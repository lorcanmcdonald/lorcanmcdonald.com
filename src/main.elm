import Browser
import Browser.Navigation as Nav
import Html exposing (..)
import Html.Attributes exposing (id, style, class, href, src, target)
import Html.Events exposing (onClick)
import Json.Decode as Decode exposing (Value)
import Markdown
import String exposing (startsWith)

type alias Model = Int

-- UPDATE

type Msg = Increment | Decrement

type Url = ExternalUrl String | AnchorLink String | LocalUrl String
toUrl : String -> Url
toUrl s = if startsWith "http" s then ExternalUrl s
          else if startsWith "#" s then AnchorLink s
          else LocalUrl s

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
           , pageTitle
           , introduction
           , projects
           , copyright
           , work
           , copyright
           , break
           , education
           , copyright
           ]

toHtml = Markdown.toHtmlWith
  { githubFlavored = Just { tables = False, breaks = False }
  , defaultHighlighting = Nothing
  , sanitize = False
  , smartypants = False
  }


copyright : Html Msg
copyright = article
  [class "small-print"]
  [toHtml [] "**This document is covered by copyright. Modifications and derived works forbidden.**"]

menu : Html Msg
menu = nav []
           [ul []
               [
                   menuLink (toUrl "#Projects") "Projects",
                   menuLink (toUrl "#WorkExperience") "Work Experience",
                   menuLink (toUrl "#Education") "Education",
                   menuLink (toUrl "http://github.com") "Github",
                   menuLink (toUrl "http://twitter.com") "Twitter"
               ] ]

introduction : Html Msg
introduction = section [] [
    article [] [ toHtml [] """
I have a passion for identifying ways to improve efficiency in software
development, especially through automation: if a computer can do it a computer
should do it. This allows my teams to spend more time on producing insights
and innovation at scale.

♥︎ Haskell, the UNIX command line, Javascript, Docker, and ♡♥︎Vim.
""" ] ]

menuLink : Url -> String -> Html Msg
menuLink url content = case url of
                       ExternalUrl u -> li [] [ a [ href u
                                                  , target "_blank"
                                                  ]
                                                  [ text content ] ]
                       AnchorLink u -> li [] [ a [ href u ] [ text content ] ]
                       LocalUrl u -> li [] [ a [ href u ] [ text content ] ]

banner : Html Msg
banner = header []
                [ div [] [ text "_" ]
                ]
pageTitle : Html Msg
pageTitle = h1 [] [ em [] [ text "Lorcan"]
              , strong [] [ text "McDonald" ]
              ]

projects : Html Msg
projects = section [ id "Projects" ]
                 [ h2 [] [ text "Projects" ]
                 , github "regexicon.com"
                     (ExternalUrl "https://github.com/lorcanmcdonald/RegexCandidates")
                     (Just (LocalUrl "images/regexicon.com.png"))
                     (toHtml [] """A common problem I've noticed when code reviewing regular expressions is
not that they don't match the intended pattern, but rather that they will match
something unexpected. I wrote this web service to help non-expert regular
expression authors identify these issues by showing a selection of strings that
would match a given regex.

You can try it out at [http://regexicon.com/](http://regexicon.com/)
""" )
                 , break
                 , github "mars" (toUrl "https://github.com/lorcanmcdonald/mars")
                     (Just (LocalUrl "images/mars-static.png"))
                     (toHtml [] """Mars is a REPL for exploring JSON
documents. It allows you to use familiar UNIX shell
commands to explore and update. It's very useful to get an overview of an unfamiliar API.

It's written in Haskell using [Parsec](https://hackage.haskell.org/package/parsec) to parse the
command line mini language.
""" )
                 ]

break : Html Msg
break = div [ class "break" ] []

work : Html Msg
work = section []
               [ h2 [ id "WorkExperience" ] [ text "Work Experience" ]
               , jetcom
               , melosity
               , serviceFrame
               , ibm
               , deecal
               , tradesports
               ]

education = section []
                    [ h2 [ id "Education"] [ text "Education" ]
                    , dcu
                    ]

dcu : Html Msg
dcu = position "BSc. Computer Applications (Software Engineering)"
               (Company "DCU" (ExternalUrl "http://www.computing.dcu.ie/"))
               (TimeSpan "Sept 1999 → May 2003")
               (toHtml [] """
Computer Applications is a four years honours degree covering practical aspects
of software engineering and theoretical topics in computer science.

My final year project was an implementation of a neural network for use in
classifying email as spam or non-spam.

I took a number of different modules Modules including:
- Software Engineering
- Languages and Computability
- Cryptography
- Graphics programming
- Systems Analysis

I also completed a six month work placement with Crannog Software, an company
selling network monitoring software.
""")

ibm : Html Msg
ibm = position "Staff Software Engineer"
               (Company "IBM" (toUrl "http://ibm.com"))
               (TimeSpan "Sept 2008 → May 2012")
               (toHtml [] """
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
and present to large audiences[³](#ibm-footnote1) (including Lotusphere 2012). I also released a
small open source library, [xspUnit](http://extlib.openntf.org/main.nsf/project.xsp?r=project/XSPUnit/releases/3A1C5BE6C1A246CA862575A10034822C),
to allow unit testing of Server Side Javascript libraries in XPages.

<a name="ibm-footnote1"></a>³ Topics included: Mobile Development, graphics programming using Quartz Mac OS X and the Vim text editor
""")

jetcom : Html Msg
jetcom = position "Associate Director"
  (Company "Walmart.com" (toUrl "https://walmart.com"))
  (TimeSpan "Aug 2017 → Present")
  (toHtml [] """
Jet.com, a subsidiary of Walmart, is an E-Commerce site targeted at urban
millennial customers. We build microservices using functional programming
languages (F#) and event sourcing by default.

I joined Jet to lead a small team working on [Associate Delivery](https://blog.walmart.com/innovation/20170601/serving-customers-in-new-ways-walmart-begins-testing-associate-delivery),
a high impact last mile initiative for Walmart to reduce shipping costs. The team was
initially going through a number of growing pains relating to leadership
changes and technical debt incurred through tight deadlines. I was quickly able
to steady the ship and move to a position where I was providing leadership for
the wider Transportation organisation comprising multiple teams across both the
Dublin (Ireland), and Hoboken (New Jersey), offices, and a number of remote
contractors and a consultancy firm.

The Transportation teams work on delivery and Last Mile problems for the Jet
and Walmart organisations. As examples instance we: provide the delivery
estimates shown to users, the cheapest shipping method that can achieve that
estimate and, in the New York Metro Area, physically deliver packages to
customers[¹](#jet-footnote1).

I am responsible for day to day managment of the teams, including prioritising
and scheduling work according to the business priorities. (Balanced against the
need to achieve a high level of operational excellence as a Tier 1 team[²](#jet-footnote2).
In addition I have a high level of involvement in the technical direction of
the team, mentoring the Engineers in Functional programming and DevOps
concepts, reviewing architectural choices in the wider organisation and
monitoring and identifying issues and risks in the various
microservices (especially as required to go into the Peak holiday shopping
season).

<a name="jet-footnote1"></a>¹ One of the teams is
[Parcel](https://www.fromparcel.com). We can guarantee delivery within a three
hour window chosen by the customer and will reduce that window in the coming
months.

<a name="jet-footnote2"></a>² A team involved in the live customer facing
discovery and checkout process.
""")
melosity : Html Msg
melosity = position "Chief Technical Officer"
                        (Company "Melosity" (toUrl "http://melosity.com"))
                        (TimeSpan "Nov 2015 → Jul 2017")
               (toHtml [] """
At Melosity we were changing the way that musicians
collaborate together. We built a way to record and arrange a music project
directly in the browser between multiple contributers, in real time[¹](#melosity-footnote1).

As the CTO of an early stage start up, my responsibilites were split between
between architecting the product and infrastructure of the product and scaling
up the team. We launched to the public in September 2016.

Melosity is primarily built using [React](https://facebook.github.io/react/),
[Haskell](https://www.haskell.org) and [Postgres](https://www.postgresql.org)
stack. We use the microservices design pattern to for continuous deployment and
decoupling of unrelated processes. [Docker](https://www.docker.com),
[Elastic Beanstalk](https://aws.amazon.com/elasticbeanstalk/details/) and
[Terraform](https://www.terraform.io) allow us
[Continously Deliver](https://en.wikipedia.org/wiki/Continuous_delivery) as
tasks are reviewed and completed.

As important as the product was the team. I instituted a agile development
process based on [Kanban](https://en.wikipedia.org/wiki/Kanban_(development)).
We held regular retrospective meetings with all stakeholders to improve our
throughput and to help non-technical team members to understand and contribute
to the software development process. In addition I hold regular one-to-one
meetings with the engineering team to make sure we are meeting their objectives
with respect to their professional practice.

<a name="melosity-footnote1"></a>¹ [Firm Real Time](https://en.wikipedia.org/wiki/Real-time_computing#Criteria_for_real-time_computing).
We need to process each frame of audio within approximately 6ms to ensure that
a user's recording doesn't glitch.
""")

serviceFrame : Html Msg
serviceFrame = position "Principal Engineer"
                        (Company "ServiceFrame" (toUrl "http://serviceframe.com"))
                        (TimeSpan "May 2012 → Nov 2015")
               (toHtml [] """
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
CoffeeScript framework, a .Net 4.5 C# application serving a JSON
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
Docker to produce an [Immutable
Infrastructure](http://martinfowler.com/bliki/ImmutableServer.html#footnote-coin)
style deployment.

<a name="sf-footnote2"></a>² [Extract, Transform, Load](https://en.wikipedia.org/wiki/Extract,_transform,_load)
""")

deecal : Html Msg
deecal = position "Senior Full Stack Developer"
                  (Company "Deecal International (later acquired by FirstData)" (toUrl "http://www.deecal.ie"))
                  (TimeSpan "Nov 2006 → Sept 2008")
               (toHtml [] """
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
with special responsibility for improving knowledge and processes in the front
end code.

This allowed me to introduce the team to the (at the time still reasonably new)
concepts of [AJAX](https://en.wikipedia.org/wiki/Ajax_(programming)),
[Unobtrusive Javascript](https://en.wikipedia.org/wiki/Unobtrusive_JavaScript)
and [jQuery](https://jquery.com).

Deecal International was acquired by FirstData in 2008.
""")

tradesports : Html Msg
tradesports = position "Software Developer"
                  (Company "Trade Exchange Network"
                    (toUrl "https://en.wikipedia.org/wiki/Intrade"))
                  (TimeSpan "Feb 2004 → Nov 2006")
               (toHtml [] """
Trade Exchange Network ran a number of prediction market products open to
public customers and in-house for a number of private clients. The consumer
sites included intrade.com, which catered primarily to financial and public
policy contracts and tradesports.com, which modelled sports betting as a futures
market.

This was my first position after completing my studies and I quickly gained
responsibility for large parts of the system as I showed an aptitude for web
development and UNIX systems administration.

I was personally responsible for the frontend code (i.e. Java Server Pages,
Javascript, HTML and CSS) for all the consumer properties. During my time there
I wrote an AJAX trading interface to show price updates in real time[⁴](tradesports-footnote1) and allow
users to buy and sell contracts. Speed and correctness was particularly
important as this would be used to trade real money during fast moving sporting
and political events.

I was responsible for converting the sites from tables based designs to CSS. This
allowed us to swiftly produce high quality reskined sites for internal
corporate markets, typically within hours of a request coming in, this would
have taken weeks of work previously and was prone to mistakes.

<a name="tradesports-footnote1"></a>⁴ Soft real time.
""")

github : String -> Url -> Maybe Url -> Html Msg -> Html Msg
github = project "fa fa-github"

twitter : String -> Url -> Maybe Url -> Html Msg -> Html Msg
twitter = project "fa fa-twitter"

project : String -> String -> Url -> Maybe Url -> Html Msg -> Html Msg
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

position : String -> Company -> TimeSpan -> Html Msg -> Html Msg
position title (Company companyName companyUrl) (TimeSpan when) about =
    let
        urlString = fromUrl companyUrl
    in
       article []
       <| List.append [ h3 [] [ text title ]
          , h4 [] [a [ href urlString ] [ text companyName ] ]
          , span [class "timespan"] [ text when ]
          ] [ about ]

update : Msg -> Model -> Model
update action model =
    case action of
        Increment -> model + 1
        Decrement -> model - 1

-- VIEW

view : Model -> Html Msg
view model = home

init = 1

main : Program () Model Msg
main =
  Browser.sandbox
    { init = init
    , update = update
    , view = view
    }
