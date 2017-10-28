## Welcome ~~~


### 求原码、补码，反码（C语言源代码，第一个博客，练练手）
####               张恒 （2017.10.28）



    #include <stdio.h>

    #define N 8 //这里你要求是8位

    int main(int argc, const char * argv[]) {

        int binary[8];//用于存放最后取得的补码

        int a=0;//要处理的数值

        int a1=0;//保存a的值

        int m=0;//用于存放临时的数值

        printf("请输入要转换成二进制补码的数的值：\n");

        scanf("%d",&a);

        a1=a;

        if (a==0) {

            for (int i=0; i<N; i++) {

                binary[i]=0;

            }

        }else if (a<0){//负数部分开始

            binary[0]=1;

            a=-a;



            //求原码部分开始

            for (int i=N-1; i>0; i--) {

                binary[i]=a%2;

                a=a/2;

                if (a<1) {

                    m=i;

                    break;

                }

            }//求源码部分结束

            printf("%d的原码值为：          ",a1);

            for (int i=0; i<N; i++) {

                printf("%d",binary[i]);

            }

            printf("\n");

            for (int i=m; i<N; i++) {//负数取反部分，第一位符号位不变。

                if (binary[i]==0) {

                    binary[i]=1;

                }

                else binary[i]=0;

            }



            binary[N-1]=binary[N-1]+1;

            for (int i=N-1; i>0; i--) {

                if (binary[i]>1) {

                    binary[i]=0;

                    binary[i-1]=binary[i-1]+1;

                    if (binary[i-1]<2) {

                        break;

                    }

                }

            }

            //负数部分结束





        }else{

            binary[0]=0;

            for (int i=N-1; i>0; i--) {

                    binary[i]=a%2;

                    a=a/2;

                if (a<1) {

                    m=i;

                    break;

                }

            }

            for (int i=1; i<m; i++) {

                binary[i]=0;

            }

            printf("%d的原码值为：          ",a1);

            for (int i=0; i<N; i++) {

                printf("%d",binary[i]);

            }

            printf("\n");

        }

        printf("%d的补码值为：          ",a1);

        for (int i=0; i<N; i++) {

            printf("%d",binary[i]);

        }

        printf("\n");

        return 0;

    }


