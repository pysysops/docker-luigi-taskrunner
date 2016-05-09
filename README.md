# luigi-task

This container is pretty much exclusively for running luigi tasks as short-lived
ephemereal containers.

The ENTRYPOINT is a shell script which activates a virtualenv, tests for the
presence of a requirements.txt file, pip installs the packages from the file and
exec's out to the luigi command.

To test the hello_world task you can run it with the --local-scheduler argument
like this:
```
docker run --rm pysysops/luigi-task --module hello_world HelloWorldTask --local-scheduler
```
Note the --rm argument passed to docker run to cleanup the container after it's
run the task.

Cool! So we've got output and it seems to "work". But running those tasks alone
doesn't show us anything or do any scheduling or anything.

So, let's go ahead and run a luigid (Central Scheduling Server) container
```
docker run -d -p 8082:8082 --name luigid pysysops/luigid
```
luigid is now running on port 8082.

Now, let's run the hello_world task again and link the container to our luigid
container
```
docker run --rm --link luigid pysysops/luigi-task --module hello_world HelloWorldTask
```
If everthing worked as it should, you can open up http://localhost:8082 in a
browser and you should see that a HelloWorldTask ran.

Great!! Now you can mount a volume with task code in it to /luigi/tasks and run
your own Luigi tasks in disposable containers.

Cron the docker run or schedule / manually run it with your favourite CI server
and enjoy the data.
