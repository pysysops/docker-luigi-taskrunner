import luigi
import pymssql
class HelloWorldTask(luigi.Task):

    def run(self):
        print("{task} says: Hello world!".format(task=self.__class__.__name__))

if __name__ == '__main__':
    luigi.run(['HelloWorldTask', '--workers', '1', '--local-scheduler'])
