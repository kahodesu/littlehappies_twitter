//This function finds the oldest file and tweets it

void tweet(File dir, File[] list) {

//re-sorts list to have oldest to newest file
  Arrays.sort(list, new Comparator<File>() {        
    public int compare(File f1, File f2)
    {
      return Long.valueOf(f1.lastModified()).compareTo(f2.lastModified());
    }
  }
  );
  //println(list[0]); //FOR DEBUG //the oldest file

  try 
  {
    str = list[0].getName();                                                        //turns oldest filename into a string
    StatusUpdate status = new StatusUpdate(str.substring(0, str.lastIndexOf('.'))); //drops extension, filename becomes text in tweet
    status.setMedia(list[0]);                                                       //attaches the image
    twitter.updateStatus(status);                                                   //tweets it!
   printArray(list);
  }
  catch (TwitterException te)
  {
    println("Error: "+ te.getMessage());
  }

//oldest file after tweeting is then deleted
  if (list[0].exists()) { 
    list[0].delete(); //the tweeted image gets deleted here! bye bye image *waves*
  } 
//otherwise we can assume that the folder is empty so nothing happens
  //else {
   // println("------ folder is empty -------");
  //}
}