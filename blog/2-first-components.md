# Let's Get Lightning!

We're out of the Apex woods for a little bit, and can focus on Lightning. In this module, we're going to create two Components. The first will represent a single campaign member, and the second will call our Apex controller using the first to display the list of members.

Wait? What?

We have one component that represents the list of all our campaign members. This component will execute our server-side Apex and get a the collection of members. For each member in that collection, we're going to "instantiate" (or create an instance of) our row component to display the details for that member.

![Layers of components](http://yuml.me/diagram/plain;dir:LR/class/,%20%5BCampaignMemberList%7CCampaignMemberRow%20--%20Will;CampaignMemberRow%20--%20Bob;CampaignMemberRow%20--%20Jane%5D.png)

This should help illustrate a very important fact about Lightning. If you know about Visualforce components, it's time to forget your preconcieved notions of what a "component" is. In Lightning a component is a resuable piece of UI, which could represent just a single letter or an entire app. Components can contain other components, and can be entire pages. Salesforce1 is itself a full Lightning app, and the components we are creating will exist inside SF1. Inside of our main component will be our row components, but those will be composed of more components to output text and UI. If you want to read more about the framework, check out the [Lightning Component Developer's Guide](https://developer.salesforce.com/docs/atlas.en-us.lightning.meta/lightning/intro_components.htm).

## That's enough theory, I want to build something!

Okay okay, let's start building. There are a lot of tools for developers on the Salesforce platform, but right now, the best way to build Lightning Components is with the developer console. You'll remember it from part two. 

We'll go to create our `CampaignMemberListRow` component first.

![Creating a component](https://dl.dropboxusercontent.com/spa/q8pc7mthv83x9i1/2015-07-03-13h44m/images/docs/untitled/86350e7e-631f-47b5-b650-78bf924f288b.png)

![Describe it](https://dl.dropboxusercontent.com/spa/q8pc7mthv83x9i1/2015-07-03-13h44m/images/docs/untitled/forcecom-developer-console.png)

We're dropped right into the component definition!

![Components have parts](https://dl.dropboxusercontent.com/spa/q8pc7mthv83x9i1/2015-07-03-13h44m/images/docs/untitled/forcecom-developer-console-1.png)

Now we're faced with a fact about components. They have parts! Your most basic component consists only of the component defintion. More complex components can have controllers, helpers, styles and more.